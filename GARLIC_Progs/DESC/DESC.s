	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"DESC.c"
	.comm	factores,40,4
	.comm	pesos,10,4
	.comm	nFactores,4,4
	.global	pK
	.data
	.align	2
	.type	pK, %object
	.size	pK, 4000
pK:
	.word	2
	.word	3
	.word	5
	.word	7
	.word	11
	.word	13
	.word	17
	.word	19
	.word	23
	.word	29
	.word	31
	.word	37
	.word	41
	.word	43
	.word	47
	.word	53
	.word	59
	.word	61
	.word	67
	.word	71
	.word	73
	.word	79
	.word	83
	.word	89
	.word	97
	.word	101
	.word	103
	.word	107
	.word	109
	.word	113
	.word	127
	.word	131
	.word	137
	.word	139
	.word	149
	.word	151
	.word	157
	.word	163
	.word	167
	.word	173
	.word	179
	.word	181
	.word	191
	.word	193
	.word	197
	.word	199
	.word	211
	.word	223
	.word	227
	.word	229
	.word	233
	.word	239
	.word	241
	.word	251
	.word	257
	.word	263
	.word	269
	.word	271
	.word	277
	.word	281
	.word	283
	.word	293
	.word	307
	.word	311
	.word	313
	.word	317
	.word	331
	.word	337
	.word	347
	.word	349
	.word	353
	.word	359
	.word	367
	.word	373
	.word	379
	.word	383
	.word	389
	.word	397
	.word	401
	.word	409
	.word	419
	.word	421
	.word	431
	.word	433
	.word	439
	.word	443
	.word	449
	.word	457
	.word	461
	.word	463
	.word	467
	.word	479
	.word	487
	.word	491
	.word	499
	.word	503
	.word	509
	.word	521
	.word	523
	.word	541
	.word	547
	.word	557
	.word	563
	.word	569
	.word	571
	.word	577
	.word	587
	.word	593
	.word	599
	.word	601
	.word	607
	.word	613
	.word	617
	.word	619
	.word	631
	.word	641
	.word	643
	.word	647
	.word	653
	.word	659
	.word	661
	.word	673
	.word	677
	.word	683
	.word	691
	.word	701
	.word	709
	.word	719
	.word	727
	.word	733
	.word	739
	.word	743
	.word	751
	.word	757
	.word	761
	.word	769
	.word	773
	.word	787
	.word	797
	.word	809
	.word	811
	.word	821
	.word	823
	.word	827
	.word	829
	.word	839
	.word	853
	.word	857
	.word	859
	.word	863
	.word	877
	.word	881
	.word	883
	.word	887
	.word	907
	.word	911
	.word	919
	.word	929
	.word	937
	.word	941
	.word	947
	.word	953
	.word	967
	.word	971
	.word	977
	.word	983
	.word	991
	.word	997
	.word	1009
	.word	1013
	.word	1019
	.word	1021
	.word	1031
	.word	1033
	.word	1039
	.word	1049
	.word	1051
	.word	1061
	.word	1063
	.word	1069
	.word	1087
	.word	1091
	.word	1093
	.word	1097
	.word	1103
	.word	1109
	.word	1117
	.word	1123
	.word	1129
	.word	1151
	.word	1153
	.word	1163
	.word	1171
	.word	1181
	.word	1187
	.word	1193
	.word	1201
	.word	1213
	.word	1217
	.word	1223
	.word	1229
	.word	1231
	.word	1237
	.word	1249
	.word	1259
	.word	1277
	.word	1279
	.word	1283
	.word	1289
	.word	1291
	.word	1297
	.word	1301
	.word	1303
	.word	1307
	.word	1319
	.word	1321
	.word	1327
	.word	1361
	.word	1367
	.word	1373
	.word	1381
	.word	1399
	.word	1409
	.word	1423
	.word	1427
	.word	1429
	.word	1433
	.word	1439
	.word	1447
	.word	1451
	.word	1453
	.word	1459
	.word	1471
	.word	1481
	.word	1483
	.word	1487
	.word	1489
	.word	1493
	.word	1499
	.word	1511
	.word	1523
	.word	1531
	.word	1543
	.word	1549
	.word	1553
	.word	1559
	.word	1567
	.word	1571
	.word	1579
	.word	1583
	.word	1597
	.word	1601
	.word	1607
	.word	1609
	.word	1613
	.word	1619
	.word	1621
	.word	1627
	.word	1637
	.word	1657
	.word	1663
	.word	1667
	.word	1669
	.word	1693
	.word	1697
	.word	1699
	.word	1709
	.word	1721
	.word	1723
	.word	1733
	.word	1741
	.word	1747
	.word	1753
	.word	1759
	.word	1777
	.word	1783
	.word	1787
	.word	1789
	.word	1801
	.word	1811
	.word	1823
	.word	1831
	.word	1847
	.word	1861
	.word	1867
	.word	1871
	.word	1873
	.word	1877
	.word	1879
	.word	1889
	.word	1901
	.word	1907
	.word	1913
	.word	1931
	.word	1933
	.word	1949
	.word	1951
	.word	1973
	.word	1979
	.word	1987
	.word	1993
	.word	1997
	.word	1999
	.word	2003
	.word	2011
	.word	2017
	.word	2027
	.word	2029
	.word	2039
	.word	2053
	.word	2063
	.word	2069
	.word	2081
	.word	2083
	.word	2087
	.word	2089
	.word	2099
	.word	2111
	.word	2113
	.word	2129
	.word	2131
	.word	2137
	.word	2141
	.word	2143
	.word	2153
	.word	2161
	.word	2179
	.word	2203
	.word	2207
	.word	2213
	.word	2221
	.word	2237
	.word	2239
	.word	2243
	.word	2251
	.word	2267
	.word	2269
	.word	2273
	.word	2281
	.word	2287
	.word	2293
	.word	2297
	.word	2309
	.word	2311
	.word	2333
	.word	2339
	.word	2341
	.word	2347
	.word	2351
	.word	2357
	.word	2371
	.word	2377
	.word	2381
	.word	2383
	.word	2389
	.word	2393
	.word	2399
	.word	2411
	.word	2417
	.word	2423
	.word	2437
	.word	2441
	.word	2447
	.word	2459
	.word	2467
	.word	2473
	.word	2477
	.word	2503
	.word	2521
	.word	2531
	.word	2539
	.word	2543
	.word	2549
	.word	2551
	.word	2557
	.word	2579
	.word	2591
	.word	2593
	.word	2609
	.word	2617
	.word	2621
	.word	2633
	.word	2647
	.word	2657
	.word	2659
	.word	2663
	.word	2671
	.word	2677
	.word	2683
	.word	2687
	.word	2689
	.word	2693
	.word	2699
	.word	2707
	.word	2711
	.word	2713
	.word	2719
	.word	2729
	.word	2731
	.word	2741
	.word	2749
	.word	2753
	.word	2767
	.word	2777
	.word	2789
	.word	2791
	.word	2797
	.word	2801
	.word	2803
	.word	2819
	.word	2833
	.word	2837
	.word	2843
	.word	2851
	.word	2857
	.word	2861
	.word	2879
	.word	2887
	.word	2897
	.word	2903
	.word	2909
	.word	2917
	.word	2927
	.word	2939
	.word	2953
	.word	2957
	.word	2963
	.word	2969
	.word	2971
	.word	2999
	.word	3001
	.word	3011
	.word	3019
	.word	3023
	.word	3037
	.word	3041
	.word	3049
	.word	3061
	.word	3067
	.word	3079
	.word	3083
	.word	3089
	.word	3109
	.word	3119
	.word	3121
	.word	3137
	.word	3163
	.word	3167
	.word	3169
	.word	3181
	.word	3187
	.word	3191
	.word	3203
	.word	3209
	.word	3217
	.word	3221
	.word	3229
	.word	3251
	.word	3253
	.word	3257
	.word	3259
	.word	3271
	.word	3299
	.word	3301
	.word	3307
	.word	3313
	.word	3319
	.word	3323
	.word	3329
	.word	3331
	.word	3343
	.word	3347
	.word	3359
	.word	3361
	.word	3371
	.word	3373
	.word	3389
	.word	3391
	.word	3407
	.word	3413
	.word	3433
	.word	3449
	.word	3457
	.word	3461
	.word	3463
	.word	3467
	.word	3469
	.word	3491
	.word	3499
	.word	3511
	.word	3517
	.word	3527
	.word	3529
	.word	3533
	.word	3539
	.word	3541
	.word	3547
	.word	3557
	.word	3559
	.word	3571
	.word	3581
	.word	3583
	.word	3593
	.word	3607
	.word	3613
	.word	3617
	.word	3623
	.word	3631
	.word	3637
	.word	3643
	.word	3659
	.word	3671
	.word	3673
	.word	3677
	.word	3691
	.word	3697
	.word	3701
	.word	3709
	.word	3719
	.word	3727
	.word	3733
	.word	3739
	.word	3761
	.word	3767
	.word	3769
	.word	3779
	.word	3793
	.word	3797
	.word	3803
	.word	3821
	.word	3823
	.word	3833
	.word	3847
	.word	3851
	.word	3853
	.word	3863
	.word	3877
	.word	3881
	.word	3889
	.word	3907
	.word	3911
	.word	3917
	.word	3919
	.word	3923
	.word	3929
	.word	3931
	.word	3943
	.word	3947
	.word	3967
	.word	3989
	.word	4001
	.word	4003
	.word	4007
	.word	4013
	.word	4019
	.word	4021
	.word	4027
	.word	4049
	.word	4051
	.word	4057
	.word	4073
	.word	4079
	.word	4091
	.word	4093
	.word	4099
	.word	4111
	.word	4127
	.word	4129
	.word	4133
	.word	4139
	.word	4153
	.word	4157
	.word	4159
	.word	4177
	.word	4201
	.word	4211
	.word	4217
	.word	4219
	.word	4229
	.word	4231
	.word	4241
	.word	4243
	.word	4253
	.word	4259
	.word	4261
	.word	4271
	.word	4273
	.word	4283
	.word	4289
	.word	4297
	.word	4327
	.word	4337
	.word	4339
	.word	4349
	.word	4357
	.word	4363
	.word	4373
	.word	4391
	.word	4397
	.word	4409
	.word	4421
	.word	4423
	.word	4441
	.word	4447
	.word	4451
	.word	4457
	.word	4463
	.word	4481
	.word	4483
	.word	4493
	.word	4507
	.word	4513
	.word	4517
	.word	4519
	.word	4523
	.word	4547
	.word	4549
	.word	4561
	.word	4567
	.word	4583
	.word	4591
	.word	4597
	.word	4603
	.word	4621
	.word	4637
	.word	4639
	.word	4643
	.word	4649
	.word	4651
	.word	4657
	.word	4663
	.word	4673
	.word	4679
	.word	4691
	.word	4703
	.word	4721
	.word	4723
	.word	4729
	.word	4733
	.word	4751
	.word	4759
	.word	4783
	.word	4787
	.word	4789
	.word	4793
	.word	4799
	.word	4801
	.word	4813
	.word	4817
	.word	4831
	.word	4861
	.word	4871
	.word	4877
	.word	4889
	.word	4903
	.word	4909
	.word	4919
	.word	4931
	.word	4933
	.word	4937
	.word	4943
	.word	4951
	.word	4957
	.word	4967
	.word	4969
	.word	4973
	.word	4987
	.word	4993
	.word	4999
	.word	5003
	.word	5009
	.word	5011
	.word	5021
	.word	5023
	.word	5039
	.word	5051
	.word	5059
	.word	5077
	.word	5081
	.word	5087
	.word	5099
	.word	5101
	.word	5107
	.word	5113
	.word	5119
	.word	5147
	.word	5153
	.word	5167
	.word	5171
	.word	5179
	.word	5189
	.word	5197
	.word	5209
	.word	5227
	.word	5231
	.word	5233
	.word	5237
	.word	5261
	.word	5273
	.word	5279
	.word	5281
	.word	5297
	.word	5303
	.word	5309
	.word	5323
	.word	5333
	.word	5347
	.word	5351
	.word	5381
	.word	5387
	.word	5393
	.word	5399
	.word	5407
	.word	5413
	.word	5417
	.word	5419
	.word	5431
	.word	5437
	.word	5441
	.word	5443
	.word	5449
	.word	5471
	.word	5477
	.word	5479
	.word	5483
	.word	5501
	.word	5503
	.word	5507
	.word	5519
	.word	5521
	.word	5527
	.word	5531
	.word	5557
	.word	5563
	.word	5569
	.word	5573
	.word	5581
	.word	5591
	.word	5623
	.word	5639
	.word	5641
	.word	5647
	.word	5651
	.word	5653
	.word	5657
	.word	5659
	.word	5669
	.word	5683
	.word	5689
	.word	5693
	.word	5701
	.word	5711
	.word	5717
	.word	5737
	.word	5741
	.word	5743
	.word	5749
	.word	5779
	.word	5783
	.word	5791
	.word	5801
	.word	5807
	.word	5813
	.word	5821
	.word	5827
	.word	5839
	.word	5843
	.word	5849
	.word	5851
	.word	5857
	.word	5861
	.word	5867
	.word	5869
	.word	5879
	.word	5881
	.word	5897
	.word	5903
	.word	5923
	.word	5927
	.word	5939
	.word	5953
	.word	5981
	.word	5987
	.word	6007
	.word	6011
	.word	6029
	.word	6037
	.word	6043
	.word	6047
	.word	6053
	.word	6067
	.word	6073
	.word	6079
	.word	6089
	.word	6091
	.word	6101
	.word	6113
	.word	6121
	.word	6131
	.word	6133
	.word	6143
	.word	6151
	.word	6163
	.word	6173
	.word	6197
	.word	6199
	.word	6203
	.word	6211
	.word	6217
	.word	6221
	.word	6229
	.word	6247
	.word	6257
	.word	6263
	.word	6269
	.word	6271
	.word	6277
	.word	6287
	.word	6299
	.word	6301
	.word	6311
	.word	6317
	.word	6323
	.word	6329
	.word	6337
	.word	6343
	.word	6353
	.word	6359
	.word	6361
	.word	6367
	.word	6373
	.word	6379
	.word	6389
	.word	6397
	.word	6421
	.word	6427
	.word	6449
	.word	6451
	.word	6469
	.word	6473
	.word	6481
	.word	6491
	.word	6521
	.word	6529
	.word	6547
	.word	6551
	.word	6553
	.word	6563
	.word	6569
	.word	6571
	.word	6577
	.word	6581
	.word	6599
	.word	6607
	.word	6619
	.word	6637
	.word	6653
	.word	6659
	.word	6661
	.word	6673
	.word	6679
	.word	6689
	.word	6691
	.word	6701
	.word	6703
	.word	6709
	.word	6719
	.word	6733
	.word	6737
	.word	6761
	.word	6763
	.word	6779
	.word	6781
	.word	6791
	.word	6793
	.word	6803
	.word	6823
	.word	6827
	.word	6829
	.word	6833
	.word	6841
	.word	6857
	.word	6863
	.word	6869
	.word	6871
	.word	6883
	.word	6899
	.word	6907
	.word	6911
	.word	6917
	.word	6947
	.word	6949
	.word	6959
	.word	6961
	.word	6967
	.word	6971
	.word	6977
	.word	6983
	.word	6991
	.word	6997
	.word	7001
	.word	7013
	.word	7019
	.word	7027
	.word	7039
	.word	7043
	.word	7057
	.word	7069
	.word	7079
	.word	7103
	.word	7109
	.word	7121
	.word	7127
	.word	7129
	.word	7151
	.word	7159
	.word	7177
	.word	7187
	.word	7193
	.word	7207
	.word	7211
	.word	7213
	.word	7219
	.word	7229
	.word	7237
	.word	7243
	.word	7247
	.word	7253
	.word	7283
	.word	7297
	.word	7307
	.word	7309
	.word	7321
	.word	7331
	.word	7333
	.word	7349
	.word	7351
	.word	7369
	.word	7393
	.word	7411
	.word	7417
	.word	7433
	.word	7451
	.word	7457
	.word	7459
	.word	7477
	.word	7481
	.word	7487
	.word	7489
	.word	7499
	.word	7507
	.word	7517
	.word	7523
	.word	7529
	.word	7537
	.word	7541
	.word	7547
	.word	7549
	.word	7559
	.word	7561
	.word	7573
	.word	7577
	.word	7583
	.word	7589
	.word	7591
	.word	7603
	.word	7607
	.word	7621
	.word	7639
	.word	7643
	.word	7649
	.word	7669
	.word	7673
	.word	7681
	.word	7687
	.word	7691
	.word	7699
	.word	7703
	.word	7717
	.word	7723
	.word	7727
	.word	7741
	.word	7753
	.word	7757
	.word	7759
	.word	7789
	.word	7793
	.word	7817
	.word	7823
	.word	7829
	.word	7841
	.word	7853
	.word	7867
	.word	7873
	.word	7877
	.word	7879
	.word	7883
	.word	7901
	.word	7907
	.word	7919
	.text
	.align	2
	.global	reducir
	.syntax unified
	.arm
	.fpu softvfp
	.type	reducir, %function
reducir:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #28
	str	r0, [sp, #4]
	str	r1, [sp]
	ldr	r3, [sp, #4]
	str	r3, [sp, #20]
	add	r3, sp, #12
	add	r2, sp, #16
	ldr	r1, [sp]
	ldr	r0, [sp, #20]
	bl	GARLIC_divmod
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L2
	ldr	r3, .L6
	ldr	r3, [r3]
	ldr	r1, .L6+4
	ldr	r2, [sp]
	str	r2, [r1, r3, lsl #2]
	ldr	r3, .L6
	ldr	r3, [r3]
	ldr	r2, .L6+8
	mov	r1, #0
	strb	r1, [r2, r3]
.L4:
	ldr	r3, [sp, #16]
	str	r3, [sp, #20]
	ldr	r3, .L6
	ldr	r3, [r3]
	ldr	r2, .L6+8
	ldrb	r2, [r2, r3]	@ zero_extendqisi2
	add	r2, r2, #1
	and	r1, r2, #255
	ldr	r2, .L6+8
	strb	r1, [r2, r3]
	add	r3, sp, #12
	add	r2, sp, #16
	ldr	r1, [sp]
	ldr	r0, [sp, #20]
	bl	GARLIC_divmod
	ldr	r3, [sp, #20]
	cmp	r3, #1
	bls	.L3
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L4
.L3:
	ldr	r3, .L6
	ldr	r3, [r3]
	add	r3, r3, #1
	ldr	r2, .L6
	str	r3, [r2]
.L2:
	ldr	r3, [sp, #20]
	mov	r0, r3
	add	sp, sp, #28
	@ sp needed
	ldr	pc, [sp], #4
.L7:
	.align	2
.L6:
	.word	nFactores
	.word	factores
	.word	pesos
	.size	reducir, .-reducir
	.align	2
	.global	factorizar1000
	.syntax unified
	.arm
	.fpu softvfp
	.type	factorizar1000, %function
factorizar1000:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #20
	str	r0, [sp, #4]
	ldr	r3, [sp, #4]
	str	r3, [sp, #8]
	mov	r3, #0
	str	r3, [sp, #12]
	b	.L9
.L11:
	ldr	r2, .L13
	ldr	r3, [sp, #12]
	ldr	r3, [r2, r3, lsl #2]
	mov	r1, r3
	ldr	r0, [sp, #8]
	bl	reducir
	str	r0, [sp, #8]
	ldr	r3, [sp, #12]
	add	r3, r3, #1
	str	r3, [sp, #12]
.L9:
	ldr	r3, [sp, #8]
	cmp	r3, #1
	bls	.L10
	ldr	r3, [sp, #12]
	cmp	r3, #1000
	bcs	.L10
	ldr	r2, .L13
	ldr	r3, [sp, #12]
	ldr	r2, [r2, r3, lsl #2]
	ldr	r3, [sp, #8]
	lsr	r3, r3, #1
	cmp	r2, r3
	bls	.L11
.L10:
	ldr	r3, [sp, #8]
	mov	r0, r3
	add	sp, sp, #20
	@ sp needed
	ldr	pc, [sp], #4
.L14:
	.align	2
.L13:
	.word	pK
	.size	factorizar1000, .-factorizar1000
	.align	2
	.global	factorizar
	.syntax unified
	.arm
	.fpu softvfp
	.type	factorizar, %function
factorizar:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #20
	str	r0, [sp, #4]
	ldr	r3, .L23
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, [sp, #4]
	cmp	r3, #0
	beq	.L16
	ldr	r3, [sp, #4]
	cmp	r3, #1
	bne	.L17
.L16:
	mov	r3, #0
	b	.L18
.L17:
	ldr	r0, [sp, #4]
	bl	factorizar1000
	str	r0, [sp, #12]
	ldr	r3, .L23+4
	ldr	r3, [r3, #3996]
	add	r3, r3, #2
	str	r3, [sp, #8]
	b	.L19
.L21:
	ldr	r1, [sp, #8]
	ldr	r0, [sp, #12]
	bl	reducir
	str	r0, [sp, #12]
	ldr	r3, [sp, #8]
	add	r3, r3, #2
	str	r3, [sp, #8]
.L19:
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bls	.L20
	ldr	r3, [sp, #12]
	lsr	r2, r3, #1
	ldr	r3, [sp, #8]
	cmp	r2, r3
	bcs	.L21
.L20:
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bls	.L22
	ldr	r3, .L23
	ldr	r3, [r3]
	ldr	r1, .L23+8
	ldr	r2, [sp, #12]
	str	r2, [r1, r3, lsl #2]
	ldr	r3, .L23
	ldr	r3, [r3]
	ldr	r2, .L23+12
	mov	r1, #1
	strb	r1, [r2, r3]
	ldr	r3, .L23
	ldr	r3, [r3]
	add	r3, r3, #1
	ldr	r2, .L23
	str	r3, [r2]
.L22:
	ldr	r3, .L23
	ldr	r3, [r3]
.L18:
	mov	r0, r3
	add	sp, sp, #20
	@ sp needed
	ldr	pc, [sp], #4
.L24:
	.align	2
.L23:
	.word	nFactores
	.word	pK
	.word	factores
	.word	pesos
	.size	factorizar, .-factorizar
	.section	.rodata
	.align	2
.LC0:
	.ascii	"-- Programa DESC  -  PID %2(%d) %0--\012\000"
	.align	2
.LC1:
	.ascii	"%2\012\012= %0%d\012\000"
	.align	2
.LC2:
	.ascii	"\011%3|NO factorizable!\000"
	.align	2
.LC3:
	.ascii	"\011%1|Numero PRIMO!\000"
	.align	2
.LC4:
	.ascii	"%2 *%1%d %2^ %3%d\012\000"
	.align	2
.LC5:
	.ascii	"%3|Descomposicion incorrecta!\012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	sub	sp, sp, #40
	str	r0, [sp, #4]
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bge	.L26
	mov	r3, #0
	str	r3, [sp, #4]
.L26:
	ldr	r3, [sp, #4]
	cmp	r3, #3
	ble	.L27
	mov	r3, #3
	str	r3, [sp, #4]
.L27:
	bl	GARLIC_clear
	bl	GARLIC_pid
	mov	r3, r0
	mov	r1, r3
	ldr	r0, .L41
	bl	GARLIC_printf
	ldr	r3, [sp, #4]
	cmp	r3, #2
	bne	.L28
	mov	r3, #4
	b	.L29
.L28:
	mov	r3, #8
.L29:
	str	r3, [sp, #16]
	mov	r3, #0
	str	r3, [sp, #36]
.L39:
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bne	.L30
	ldr	r3, [sp, #36]
	str	r3, [sp, #24]
	b	.L31
.L30:
	bl	GARLIC_random
	mov	r3, r0
	str	r3, [sp, #24]
	ldr	r3, [sp, #4]
	cmp	r3, #1
	ble	.L31
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #16]
	lsl	r4, r2, r3
	bl	GARLIC_random
	mov	r1, r0
	mov	r2, #1
	ldr	r3, [sp, #16]
	lsl	r3, r2, r3
	sub	r3, r3, #1
	and	r3, r3, r1
	orr	r3, r4, r3
	str	r3, [sp, #24]
.L31:
	ldr	r1, [sp, #24]
	ldr	r0, .L41+4
	bl	GARLIC_printf
	ldr	r0, [sp, #24]
	bl	factorizar
	str	r0, [sp, #12]
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L32
	ldr	r0, .L41+8
	bl	GARLIC_printf
	b	.L33
.L32:
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L34
	ldr	r3, .L41+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L34
	ldr	r0, .L41+16
	bl	GARLIC_printf
	b	.L33
.L34:
	mov	r3, #1
	str	r3, [sp, #20]
	mov	r3, #0
	str	r3, [sp, #32]
	b	.L35
.L38:
	ldr	r2, .L41+20
	ldr	r3, [sp, #32]
	ldr	r1, [r2, r3, lsl #2]
	ldr	r2, .L41+12
	ldr	r3, [sp, #32]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r0, .L41+24
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #28]
	b	.L36
.L37:
	ldr	r2, .L41+20
	ldr	r3, [sp, #32]
	ldr	r2, [r2, r3, lsl #2]
	ldr	r3, [sp, #20]
	mul	r3, r2, r3
	str	r3, [sp, #20]
	ldr	r3, [sp, #28]
	add	r3, r3, #1
	str	r3, [sp, #28]
.L36:
	ldr	r2, .L41+12
	ldr	r3, [sp, #32]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r3, [sp, #28]
	cmp	r2, r3
	bhi	.L37
	ldr	r3, [sp, #32]
	add	r3, r3, #1
	str	r3, [sp, #32]
.L35:
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #12]
	cmp	r2, r3
	bcc	.L38
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #24]
	cmp	r2, r3
	beq	.L33
	ldr	r0, .L41+28
	bl	GARLIC_printf
.L33:
	ldr	r3, [sp, #36]
	add	r3, r3, #1
	str	r3, [sp, #36]
	ldr	r3, [sp, #36]
	cmp	r3, #100
	bls	.L39
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bne	.L39
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #40
	@ sp needed
	pop	{r4, pc}
.L42:
	.align	2
.L41:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	pesos
	.word	.LC3
	.word	factores
	.word	.LC4
	.word	.LC5
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 46) 6.3.0"
