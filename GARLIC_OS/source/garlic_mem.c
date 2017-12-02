/*------------------------------------------------------------------------------

	"garlic_mem.c" : fase 1 / programador M manuel.ruiz@estudiants.urv.cat

	Funciones de carga de un fichero ejecutable en formato ELF, para GARLIC 1.0

------------------------------------------------------------------------------*/
#include <nds.h>
#include <filesystem.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <garlic_system.h>	// definición de funciones y variables de sistema

#define INI_MEM 0x01002000		// dirección inicial de memoria para programas
#define END_MEM 0x01008000		// direccion final de memoria para programas
#define EI_NIDENT 16

typedef unsigned int Elf32_Addr;
typedef unsigned short Elf32_Half;
typedef unsigned int Elf32_Off;
typedef signed int Elf32_Sword;
typedef unsigned int Elf32_Word;


typedef struct {
unsigned char e_ident[EI_NIDENT];
Elf32_Half e_type;
Elf32_Half e_machine;
Elf32_Word e_version;
Elf32_Addr e_entry;
Elf32_Off e_phoff;
Elf32_Off e_shoff;
Elf32_Word e_flags;
Elf32_Half e_ehsize;
Elf32_Half e_phentsize;
Elf32_Half e_phnum;
Elf32_Half e_shentsize;
Elf32_Half e_shnum;
Elf32_Half e_shstrndx;
} Elf32_Ehdr;

typedef struct {
Elf32_Word p_type;
Elf32_Off p_offset;
Elf32_Addr p_vaddr;
Elf32_Addr p_paddr;
Elf32_Word p_filesz;
Elf32_Word p_memsz;
Elf32_Word p_flags;
Elf32_Word p_align;
} Elf32_Phdr;






/* _gm_initFS: inicializa el sistema de ficheros, devolviendo un valor booleano
					para indiciar si dicha inicialización ha tenido éxito; */
int _gm_initFS()
{
	return nitroFSInit(NULL);
	
}



/* _gm_cargarPrograma: busca un fichero de nombre "(keyName).elf" dentro del
					directorio "/Programas/" del sistema de ficheros, y
					carga los segmentos de programa a partir de una posición de
					memoria libre, efectuando la reubicación de las referencias
					a los símbolos del programa, según el desplazamiento del
					código en la memoria destino;
	Parámetros:
		keyName ->	vector de 4 caracteres con el nombre en clave del programa
	Resultado:
		!= 0	->	dirección de inicio del programa (intFunc)
		== 0	->	no se ha podido cargar el programa
*/
intFunc _gm_cargarPrograma(char *keyName)
{
	//variables iniciales relacionadas con el cargar el vector en memoria dinámica
	long lSize;
	char *buffer;
	size_t result;
	
	
	//coger nombre del fichero
	char path[19];
	
	sprintf(path, "/Programas/%s.elf", keyName);
	
	FILE *pFile = fopen(path, "rb");
	
	if (pFile==NULL) return ((intFunc) 0);
	
	//obtener tamaño de la file
	fseek(pFile, 0, SEEK_END);
	lSize = ftell (pFile);
	fseek(pFile,0,SEEK_SET);

	
	//dar tamaño a la memoria para que contenga todo el fichero
	buffer = (char*) malloc (sizeof(char)*(lSize+1));
	if (buffer == NULL) return ((intFunc) 0);

	//copiar el fichero en el buffer
	result = fread(buffer,sizeof(char),lSize,pFile); //1 o size(char)??
	if (result!=lSize) return ((intFunc) 0);

	/*ya tenemos la file cargada en el buffer*/
	//variables para tratar con partes del archivo .elf
	Elf32_Ehdr head;
	Elf32_Phdr segments_table;
	Elf32_Off offset;
	Elf32_Half size_st;
	Elf32_Half num_st;
	Elf32_Addr entry;
	
	fseek(pFile,0,SEEK_SET);

	//buscamos la cabecera de fichero ELF
	fread(&head,1,sizeof(Elf32_Ehdr), pFile);
	
	//guardamos offset, bytes de los headers de programa, y numero de headers de programa.
	offset= head.e_phoff;
	size_st= head.e_phentsize;
	num_st= head.e_phnum;
	entry = head.e_entry;

	
	if(num_st!= 0)
	{
		fseek(pFile, offset, SEEK_SET);
		fread(&segments_table,1,sizeof(Elf32_Phdr), pFile); // lee la tabla de segmentos
	}
	
	//dirección enviada como result
	int dirprog=0; //setteada a 0 por si no hubieran segmentos = error.
	//bucle que accede a la tabla de segmentos
	int i;
	for(i=0;((i<num_st) /*&& (trobat == 0)*/);i++){
		
		//selecciona el tipo de segmento
		Elf32_Word segment_type;
		segment_type = segments_table.p_type;
		
		//comprueba que sea del tipo PT_LOAD
		if(segment_type == 1){
			//trobat = 1;
			Elf32_Off desp_prog;
			Elf32_Addr dir_ref;
			Elf32_Word size_prog;
			
			if (_gm_first_mem_pos > END_MEM) 
			{
				fclose(pFile);
				free(buffer);
				return ((intFunc)0);
			}
			//obtencion dirección inicial del segmento a cargar y desplazamiento y size programa
			desp_prog = segments_table.p_offset;
			dir_ref = segments_table.p_paddr;
			size_prog = segments_table.p_memsz;
			//copia direcciones en memoria
			_gs_copiaMem((const void *) &buffer[desp_prog],  (void *) _gm_first_mem_pos, size_prog);
			
			//hace las reubicaciones
			_gm_reubicar( buffer, dir_ref, (unsigned int *) _gm_first_mem_pos);
			
			//para que en el siguiente programa, el gm_first_mem_pos sea multiplo de 4
			int valor = size_prog%4;
			if(valor!=0){
				size_prog = size_prog + (4-valor);
			}
			//damos valor a la dirección inicial de donde se encuentra el programa en memoria
			dirprog = (int) _gm_first_mem_pos+entry-dir_ref;
			_gm_first_mem_pos = _gm_first_mem_pos + size_prog; //actualizamos para el siguiente progrma
			
		}
		
		if(i+1<num_st){
			//actualizar offset
			offset=offset+size_st;
			
			
			fseek(pFile, offset, SEEK_SET);
			fread(&segments_table,1,sizeof(Elf32_Phdr), pFile); // lee la tabla de segmentos
		}
	}
	
	//cierra fichero y buffer de memoria
	fclose(pFile);
	free(buffer);
	
	return ((intFunc) dirprog);	//devuelve la dirección del programa en que se encuentra en el segmento
	
}

