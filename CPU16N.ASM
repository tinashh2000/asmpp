EVEN 2
Keyword0:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
	DW	Keyword0High, Keyword0Desc




Keyword0High:


Keyword0Desc:
EVEN 2
Keyword1:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
	DW	Keyword1High, Keyword1Desc




Keyword1High:


Keyword1Desc:
EVEN 2
Keyword2:
	DW	000,003,008,012,026,028,029,032,032,034,044,044,046,046,047,048,048,048,050,054,054,055,055,055,055,055,055
	DW	Keyword2High, Keyword2Desc


Keyword2a:
	DW		0x5f5b	;ah low
	DW		0x9b42	;al low
	DW		0x4f3f	;ax low
Keyword2b:
	DW		0x6e1a	;bh low
	DW		0xaa03	;bl low
	DW		0xf64c	;bp low
	DW		0x3255	;bt low
	DW		0x7e7e	;bx low
Keyword2c:
	DW		0x3dd9	;ch low
	DW		0xf9c0	;cl low
	DW		0x9519	;cs low
	DW		0x2dbd	;cx low
Keyword2d:
	DW		0xe586	;db low
	DW		0x40b3	;dd low
	DW		0x219f	;df low
	DW		0x0c98	;dh low
	DW		0x5d22	;di low
	DW		0xc881	;dl low
	DW		0x4621	;do low
	DW		0x94ce	;dp low
	DW		0xc574	;dq low
	DW		0x6041	;ds low
	DW		0x50d7	;dt low
	DW		0x016d	;du low
	DW		0x2c6a	;dw low
	DW		0x1cfc	;dx low
Keyword2e:
	DW		0x329f	;eq low
	DW		0x53b3	;es low
Keyword2f:
	DW		0x62f2	;fs low
Keyword2g:
	DW		0x8460	;ge low
	DW		0x3131	;gs low
	DW		0x01a7	;gt low
Keyword2h:
Keyword2i:
	DW		0xf854	;if low
	DW		0x7066	;in low
Keyword2j:
	DW		0x61d5	;ja low
	DW		0x0d0c	;jb low
	DW		0x5cb6	;jc low
	DW		0x3d9a	;je low
	DW		0x98af	;jg low
	DW		0x200b	;jl low
	DW		0x109d	;jo low
	DW		0x7c44	;jp low
	DW		0x4cd2	;js low
	DW		0x955a	;jz low
Keyword2k:
Keyword2l:
	DW		0xd72a	;le low
	DW		0xdadf	;lt low
Keyword2m:
Keyword2n:
	DW		0x5dab	;ne low
Keyword2o:
	DW		0x9604	;or low
Keyword2p:
Keyword2q:
Keyword2r:
	DW		0x2dbf	;r8 low
	DW		0x7c05	;r9 low
Keyword2s:
	DW		0xba2b	;si low
	DW		0xb7de	;sp low
	DW		0x8748	;ss low
	DW		0x73c7	;st low
Keyword2t:
Keyword2u:
	DW		0x6110	;ud low


Keyword2High:
	DW		0xefb5	;ah high
	DW		0xe8d8	;al high
	DW		0xf202	;ax high
	DW		0xf6ae	;bh high
	DW		0xf1c3	;bl high
	DW		0xe5c2	;bp high
	DW		0xe2af	;bt high
	DW		0xeb19	;bx high
	DW		0xdd83	;ch high
	DW		0xdaee	;cl high
	DW		0xb9e8	;cs high
	DW		0xc034	;cx high
	DW		0x244d	;db high
	DW		0xcd2e	;dd high
	DW		0x2320	;df high
	DW		0xc498	;dh high
	DW		0x5d91	;di high
	DW		0xc3f5	;dl high
	DW		0x00f9	;do high
	DW		0xd7f4	;dp high
	DW		0x4efd	;dq high
	DW		0xa79e	;ds high
	DW		0xd099	;dt high
	DW		0x4990	;du high
	DW		0xae28	;dw high
	DW		0xd92f	;dx high
	DW		0xefb2	;eq high
	DW		0x01bc	;es high
	DW		0x18a7	;fs high
	DW		0xc75e	;ge high
	DW		0x338a	;gs high
	DW		0x448d	;gt high
	DW		0xc0d4	;if high
	DW		0xce0f	;in high
	DW		0xbda4	;ja high
	DW		0xdea2	;jb high
	DW		0x47ab	;jc high
	DW		0xa9a5	;je high
	DW		0x40c6	;jg high
	DW		0x391a	;jl high
	DW		0x4e1d	;jo high
	DW		0x2d1b	;jp high
	DW		0x5a1c	;js high
	DW		0xcdce	;jz high
	DW		0x9548	;le high
	DW		0x1840	;lt high
	DW		0x24aa	;ne high
	DW		0x4d35	;or high
	DW		0xd707	;r8 high
	DW		0x4e0e	;r9 high
	DW		0x0925	;si high
	DW		0x842d	;sp high
	DW		0xf32a	;ss high
	DW		0x8340	;st high
	DW		0x21ce	;ud high


Keyword2Desc:
	DB		Reg8, 4	
	DB		Reg8, 0	
	DB		Reg16, 0	
	DB		Reg8, 7	
	DB		Reg8, 3	
	DB		Reg16, 5	
	DW		(btInstr)	
	DB		Reg16, 3	
	DB		Reg8, 5	
	DB		Reg8, 1	
	DB		segReg, 1	
	DB		Reg16, 1	
	DW		(DBDirective)	
	DW		(DDDirective)	
	DW		(DFDirective)	
	DB		Reg8, 6	
	DB		Reg16, 7	
	DB		Reg8, 2	
	DW		(DODirective)	
	DW		(DFDirective)	
	DW		(DQDirective)	
	DB		segReg, 3	
	DW		(DTDirective)	
	DW		(DUDirective)	
	DW		(DWDirective)	
	DB		Reg16, 2	
	DB		operator, booleqop	
	DB		segReg, 0	
	DB		segReg386, 0	
	DB		operator, geop	
	DB		segReg386, 1	
	DB		operator, gtop	
	DW		(IfDirective)	
	DW		(inInstr)	
	DW		(jaInstr)	
	DW		(jbInstr)	
	DW		(jbInstr)	
	DW		(jzInstr)	
	DW		(jgInstr)	
	DW		(jlInstr)	
	DW		(joInstr)	
	DW		(jpInstr)	
	DW		(jsInstr)	
	DW		(jzInstr)	
	DB		operator, leop	
	DB		operator, ltop	
	DB		operator, neop	
	DW		(orInstr)	
	DB		LMReg64, 0	
	DB		LMReg64, 1	
	DB		Reg16, 6	
	DB		Reg16, 4	
	DB		segReg, 2	
	DB		FPUReg, 0	
	DW		(udInstr)	
EVEN 2
Keyword3:
	DW	000,007,013,032,050,061,065,065,066,070,087,087,097,108,111,113,116,116,144,166,174,175,175,175,176,176,176
	DW	Keyword3High, Keyword3Desc


Keyword3a:
	DW		0xe581	;aaa low
	DW		0xb43b	;aad low
	DW		0x2198	;aam low
	DW		0x50d0	;aas low
	DW		0xd76e	;adc low
	DW		0xe7f8	;add low
	DW		0x0f72	;and low
Keyword3b:
	DW		0xd2a8	;bpl low
	DW		0xf29f	;bsf low
	DW		0xaed0	;bsr low
	DW		0x0a3d	;btc low
	DW		0x07c8	;btr low
	DW		0x1a59	;bts low
Keyword3c:
	DW		0xd5ce	;cbw low
	DW		0x7248	;cdq low
	DW		0x8908	;clc low
	DW		0xb99e	;cld low
	DW		0xa40f	;cli low
	DW		0xbafa	;cmc low
	DW		0x5e11	;cmp low
	DW		0x40a8	;cqo low
	DW		0xb699	;cr0 low
	DW		0x233a	;cr1 low
	DW		0x13ac	;cr2 low
	DW		0x4216	;cr3 low
	DW		0xfab2	;cr4 low
	DW		0xe723	;cr5 low
	DW		0xd7b5	;cr6 low
	DW		0x860f	;cr7 low
	DW		0x3eab	;cr8 low
	DW		0xab08	;cr9 low
	DW		0x1086	;cwd low
Keyword3d:
	DW		0x5ac5	;daa low
	DW		0xef94	;das low
	DW		0x9fc1	;dec low
	DW		0x562d	;def low
	DW		0xcd5c	;dil low
	DW		0x3426	;div low
	DW		0x39dc	;dqw low
	DW		0x799b	;dr0 low
	DW		0xec38	;dr1 low
	DW		0x18b7	;dr2 low
	DW		0x490d	;dr3 low
	DW		0xbd82	;dr4 low
	DW		0xa013	;dr5 low
	DW		0xdcae	;dr6 low
	DW		0x8d14	;dr7 low
	DW		0xf1a9	;dr8 low
	DW		0x640a	;dr9 low
	DW		0xad62	;dup low
Keyword3e:
	DW		0x421b	;eax low
	DW		0x3f71	;ebp low
	DW		0xb743	;ebx low
	DW		0xb8cf	;ecx low
	DW		0x1e17	;edi low
	DW		0x9bd0	;edx low
	DW		0xc52c	;end low
	DW		0x89c2	;equ low
	DW		0x5e11	;esc low
	DW		0xb70f	;esi low
	DW		0xbafa	;esp low
Keyword3f:
	DW		0x6407	;far low
	DW		0xf0fa	;fld low
	DW		0x74ea	;for low
	DW		0xb1e1	;fst low
Keyword3g:
Keyword3h:
	DW		0x68bf	;hlt low
Keyword3i:
	DW		0xaa45	;inc low
	DW		0xba21	;ins low
	DW		0x4eae	;int low
	DW		0xb6c6	;irp low
Keyword3j:
	DW		0x277b	;jae low
	DW		0x2a4b	;jbe low
	DW		0xdda0	;jge low
	DW		0x66e9	;jle low
	DW		0x14c5	;jmp low
	DW		0xc072	;jna low
	DW		0xf0e4	;jnb low
	DW		0xa15e	;jnc low
	DW		0x046b	;jne low
	DW		0x6547	;jng low
	DW		0x19fa	;jnl low
	DW		0xed75	;jno low
	DW		0xcd87	;jnp low
	DW		0xb13a	;jns low
	DW		0x68b2	;jnz low
	DW		0x5a98	;jpe low
	DW		0x779f	;jpo low
Keyword3k:
Keyword3l:
	DW		0x4bbe	;lar low
	DW		0x8dde	;lds low
	DW		0x456c	;lea low
	DW		0xf03d	;les low
	DW		0xef5c	;lfs low
	DW		0xbc9f	;lgs low
	DW		0xf28e	;low low
	DW		0x663f	;lsl low
	DW		0xceff	;lss low
	DW		0xce35	;ltr low
Keyword3m:
	DW		0x3038	;mm0 low
	DW		0x6182	;mm1 low
	DW		0x5114	;mm2 low
	DW		0xc4b7	;mm3 low
	DW		0xf421	;mm4 low
	DW		0xa59b	;mm5 low
	DW		0x950d	;mm6 low
	DW		0x98f8	;mm7 low
	DW		0xc757	;mod low
	DW		0xb61f	;mov low
	DW		0xb5be	;mul low
Keyword3n:
	DW		0x1450	;neg low
	DW		0x1831	;nop low
	DW		0xdc28	;not low
Keyword3o:
	DW		0x90d7	;org low
	DW		0xf986	;out low
Keyword3p:
	DW		0x8074	;pop low
	DW		0xad73	;por low
	DW		0x381a	;ptr low
Keyword3q:
Keyword3r:
	DW		0x5dc6	;r10 low
	DW		0x4057	;r11 low
	DW		0x70c1	;r12 low
	DW		0x217b	;r13 low
	DW		0x11ed	;r14 low
	DW		0x844e	;r15 low
	DW		0xf8fe	;r8b low
	DW		0x99d2	;r8d low
	DW		0x7d39	;r8w low
	DW		0xe716	;r9b low
	DW		0x0e08	;r9d low
	DW		0x2efa	;r9w low
	DW		0x4102	;rax low
	DW		0x3c68	;rbp low
	DW		0xb45a	;rbx low
	DW		0x97cc	;rcl low
	DW		0xaaaf	;rcr low
	DW		0x43b1	;rcx low
	DW		0x332e	;rdi low
	DW		0x72f0	;rdx low
	DW		0xa901	;rep low
	DW		0x6d18	;ret low
	DW		0xf7fd	;rol low
	DW		0x0e87	;ror low
	DW		0xd427	;rsi low
	DW		0x6a11	;rsm low
	DW		0xd9d2	;rsp low
	DW		0xcbcf	;rva low
Keyword3s:
	DW		0x2a3b	;sal low
	DW		0xd341	;sar low
	DW		0x9255	;sbb low
	DW		0xbcbf	;seg low
	DW		0x57d8	;shl low
	DW		0x6abb	;shr low
	DW		0xec18	;sil low
	DW		0x09e1	;smi low
	DW		0xcf81	;spl low
	DW		0x3a5d	;st0 low
	DW		0x27cc	;st1 low
	DW		0x175a	;st2 low
	DW		0x46e0	;st3 low
	DW		0x7676	;st4 low
	DW		0xe3d5	;st5 low
	DW		0xd343	;st6 low
	DW		0x82f9	;st7 low
	DW		0x1714	;stc low
	DW		0x2782	;std low
	DW		0xfe0a	;sti low
	DW		0x56ca	;str low
	DW		0x3b4d	;sub low
Keyword3t:
	DW		0x7fde	;tr0 low
	DW		0xea7d	;tr1 low
	DW		0xdaeb	;tr2 low
	DW		0x8b51	;tr3 low
	DW		0x33f5	;tr4 low
	DW		0x2e64	;tr5 low
	DW		0x1ef2	;tr6 low
	DW		0x4f48	;tr7 low
Keyword3u:
	DW		0xbf13	;ud2 low
Keyword3v:
Keyword3w:
Keyword3x:
	DW		0x3e97	;xor low


Keyword3High:
	DW		0xdf1f	;aaa high
	DW		0x4616	;aad high
	DW		0xd872	;aam high
	DW		0x2bcb	;aas high
	DW		0x1a3c	;adc high
	DW		0x6d3b	;add high
	DW		0x97d4	;and high
	DW		0x4c8c	;bpl high
	DW		0xba56	;bsf high
	DW		0xae57	;bsr high
	DW		0xb85f	;btc high
	DW		0x3557	;btr high
	DW		0xa5e8	;bts high
	DW		0xbc5b	;cbw high
	DW		0xea01	;cdq high
	DW		0xd161	;clc high
	DW		0xa666	;cld high
	DW		0x36d9	;cli high
	DW		0x7743	;cmc high
	DW		0x1a9e	;cmp high
	DW		0xbe55	;cqo high
	DW		0xf742	;cr0 high
	DW		0x6926	;cr1 high
	DW		0x1e21	;cr2 high
	DW		0x8728	;cr3 high
	DW		0xfef4	;cr4 high
	DW		0x6e4b	;cr5 high
	DW		0x194c	;cr6 high
	DW		0x8045	;cr7 high
	DW		0xf999	;cr8 high
	DW		0x67fd	;cr9 high
	DW		0x3d66	;cwd high
	DW		0xbe58	;daa high
	DW		0x4a8c	;das high
	DW		0xda34	;dec high
	DW		0x5051	;def high
	DW		0xe63e	;dil high
	DW		0x1b5c	;div high
	DW		0x0723	;dqw high
	DW		0x1fe3	;dr0 high
	DW		0x8187	;dr1 high
	DW		0xf1ed	;dr2 high
	DW		0x68e4	;dr3 high
	DW		0x188e	;dr4 high
	DW		0x8831	;dr5 high
	DW		0xf680	;dr6 high
	DW		0x6f89	;dr7 high
	DW		0x1138	;dr8 high
	DW		0x8f5c	;dr9 high
	DW		0xfa46	;dup high
	DW		0xea27	;eax high
	DW		0xfa8a	;ebp high
	DW		0xf451	;ebx high
	DW		0xcb7d	;ecx high
	DW		0x8a00	;edi high
	DW		0x09d3	;edx high
	DW		0xa2eb	;end high
	DW		0x3737	;equ high
	DW		0xf1d5	;esc high
	DW		0x1100	;esi high
	DW		0x9c08	;esp high
	DW		0xe253	;far high
	DW		0x6b10	;fld high
	DW		0x86df	;for high
	DW		0x73c4	;fst high
	DW		0x6122	;hlt high
	DW		0xe9ad	;inc high
	DW		0xf41a	;ins high
	DW		0x8470	;int high
	DW		0x8b64	;irp high
	DW		0xbcdb	;jae high
	DW		0xadb9	;jbe high
	DW		0x0cf6	;jge high
	DW		0xdd34	;jle high
	DW		0xffa8	;jmp high
	DW		0xe86f	;jna high
	DW		0x9f68	;jnb high
	DW		0x0661	;jnc high
	DW		0xef02	;jne high
	DW		0x010c	;jng high
	DW		0x7fbd	;jnl high
	DW		0x0fd7	;jno high
	DW		0x6567	;jnp high
	DW		0x1bd6	;jns high
	DW		0x8c04	;jnz high
	DW		0xd54d	;jpe high
	DW		0x32f5	;jpo high
	DW		0x57f4	;lar high
	DW		0xe2bd	;lds high
	DW		0x7fff	;lea high
	DW		0x8b2b	;les high
	DW		0xd08b	;lfs high
	DW		0xfba6	;lgs high
	DW		0x3412	;low high
	DW		0x5800	;lsl high
	DW		0x3c6b	;lss high
	DW		0x3176	;ltr high
	DW		0xd9e5	;mm0 high
	DW		0x40ec	;mm1 high
	DW		0x37eb	;mm2 high
	DW		0xa98f	;mm3 high
	DW		0xde88	;mm4 high
	DW		0x4781	;mm5 high
	DW		0x3086	;mm6 high
	DW		0xbd8e	;mm7 high
	DW		0x87d5	;mod high
	DW		0x746c	;mov high
	DW		0x3923	;mul high
	DW		0xe5f1	;neg high
	DW		0x72c3	;nop high
	DW		0x75ae	;not high
	DW		0x4a92	;org high
	DW		0x29cb	;out high
	DW		0x78f1	;pop high
	DW		0x9f49	;por high
	DW		0x0c30	;ptr high
	DW		0x0e9b	;r10 high
	DW		0x9e24	;r11 high
	DW		0xe923	;r12 high
	DW		0x702a	;r13 high
	DW		0x072d	;r14 high
	DW		0x9949	;r15 high
	DW		0x61bc	;r8b high
	DW		0x8fb2	;r8d high
	DW		0xe26f	;r8w high
	DW		0x4327	;r9b high
	DW		0xa3f2	;r9d high
	DW		0xc942	;r9w high
	DW		0xc2fc	;rax high
	DW		0xd251	;rbp high
	DW		0xdc8a	;rbx high
	DW		0x671f	;rcl high
	DW		0x9d10	;rcr high
	DW		0x7dc5	;rcx high
	DW		0xe060	;rdi high
	DW		0x64de	;rdx high
	DW		0x4128	;rep high
	DW		0x4645	;ret high
	DW		0xea10	;rol high
	DW		0x1772	;ror high
	DW		0xb4d4	;rsi high
	DW		0x00df	;rsm high
	DW		0x39dc	;rsp high
	DW		0x964f	;rva high
	DW		0xb961	;sal high
	DW		0x4403	;sar high
	DW		0xcda0	;sbb high
	DW		0x8206	;seg high
	DW		0xd0f7	;shl high
	DW		0x2af8	;shr high
	DW		0x780e	;sil high
	DW		0xe7a5	;smi high
	DW		0x52ec	;spl high
	DW		0xb3e5	;st0 high
	DW		0x235a	;st1 high
	DW		0x545d	;st2 high
	DW		0xcd54	;st3 high
	DW		0xba53	;st4 high
	DW		0x2437	;st5 high
	DW		0x5330	;st6 high
	DW		0xca39	;st7 high
	DW		0xa63f	;stc high
	DW		0xd138	;std high
	DW		0x46ea	;sti high
	DW		0x2281	;str high
	DW		0x56a0	;sub high
	DW		0xeaa6	;tr0 high
	DW		0x74c2	;tr1 high
	DW		0x03c5	;tr2 high
	DW		0x9acc	;tr3 high
	DW		0xe310	;tr4 high
	DW		0x73af	;tr5 high
	DW		0x04a8	;tr6 high
	DW		0x9da1	;tr7 high
	DW		0xa246	;ud2 high
	DW		0x6372	;xor high


Keyword3Desc:
	DW		(aaaInstr)	
	DW		(aadInstr)	
	DW		(aamInstr)	
	DW		(aasInstr)	
	DW		(adcInstr)	
	DW		(addInstr)	
	DW		(andInstr)	
	DB		lmlowReg, 5	
	DW		(bsfInstr)	
	DW		(bsrInstr)	
	DW		(btcInstr)	
	DW		(btrInstr)	
	DW		(btsInstr)	
	DW		(cbwInstr)	
	DW		(cdqInstr)	
	DW		(clcInstr)	
	DW		(cldInstr)	
	DW		(cliInstr)	
	DW		(cmcInstr)	
	DW		(cmpInstr)	
	DW		(cqoInstr)	
	DB		CtrlReg, 0	
	DB		CtrlReg, 1	
	DB		CtrlReg, 2	
	DB		CtrlReg, 3	
	DB		CtrlReg, 4	
	DB		CtrlReg, 5	
	DB		CtrlReg, 6	
	DB		CtrlReg, 7	
	DB		CtrlReg64, 0	
	DB		CtrlReg64, 1	
	DW		(cwdInstr)	
	DW		(daaInstr)	
	DW		(dasInstr)	
	DW		(decInstr)	
	DB		operator, 1	
	DB		lmlowReg, 7	
	DW		(divInstr)	
	DW		(DODirective)	
	DB		DbgReg, 0	
	DB		DbgReg, 1	
	DB		DbgReg, 2	
	DB		DbgReg, 3	
	DB		DbgReg, 4	
	DB		DbgReg, 5	
	DB		DbgReg, 6	
	DB		DbgReg, 7	
	DB		DbgReg64, 0	
	DB		DbgReg64, 1	
	DW		(DUPDirective)	
	DB		Reg32, 0	
	DB		Reg32, 5	
	DB		Reg32, 3	
	DB		Reg32, 1	
	DB		Reg32, 7	
	DB		Reg32, 2	
	DW		(ENDDirective)	
	DW		(EQUDirective)	
	DW		(EscInstr)	
	DB		Reg32, 6	
	DB		Reg32, 4	
	DB		distspec, 3	
	DW		(fldInstr)	
	DW		(ForDirective)	
	DW		(fstInstr)	
	DW		(hltInstr)	
	DW		(incInstr)	
	DW		(insInstr)	
	DW		(intInstr)	
	DW		(IRPDirective)	
	DW		(jaeInstr)	
	DW		(jbeInstr)	
	DW		(jgeInstr)	
	DW		(jleInstr)	
	DW		(jmpInstr)	
	DW		(jbeInstr)	
	DW		(jaeInstr)	
	DW		(jncInstr)	
	DW		(jnzInstr)	
	DW		(jleInstr)	
	DW		(jgeInstr)	
	DW		(jnoInstr)	
	DW		(jpoInstr)	
	DW		(jnsInstr)	
	DW		(jnzInstr)	
	DW		(jpInstr)	
	DW		(jpoInstr)	
	DW		(larInstr)	
	DW		(ldsInstr)	
	DW		(leaInstr)	
	DW		(lesInstr)	
	DW		(lfsInstr)	
	DW		(lgsInstr)	
	DB		operator, 2	
	DW		(lslInstr)	
	DW		(lssInstr)	
	DW		(ltrInstr)	
	DB		mmxReg, 0	
	DB		mmxReg, 1	
	DB		mmxReg, 2	
	DB		mmxReg, 3	
	DB		mmxReg, 4	
	DB		mmxReg, 5	
	DB		mmxReg, 6	
	DB		mmxReg, 7	
	DB		operator, modop	
	DW		(movInstr)	
	DW		(mulInstr)	
	DW		(negInstr)	
	DW		(nopInstr)	
	DW		(notInstr)	
	DW		(OrgDirective)	
	DW		(outInstr)	
	DW		(popInstr)	
	DW		(porInstr)	
	DB		operator, PtrOp	
	DB		LMReg64, 2	
	DB		LMReg64, 3	
	DB		LMReg64, 4	
	DB		LMReg64, 5	
	DB		LMReg64, 6	
	DB		LMReg64, 7	
	DB		LMReg8, 0	
	DB		LMReg32, 0	
	DB		LMReg16, 0	
	DB		LMReg8, 1	
	DB		LMReg32, 1	
	DB		LMReg16, 1	
	DB		Reg64, 0	
	DB		Reg64, 5	
	DB		Reg64, 3	
	DW		(rclInstr)	
	DW		(rcrInstr)	
	DB		Reg64, 1	
	DB		Reg64, 7	
	DB		Reg64, 2	
	DW		(repInstr)	
	DW		(retInstr)	
	DW		(rolInstr)	
	DW		(rorInstr)	
	DB		Reg64, 6	
	DW		(rsmInstr)	
	DB		Reg64, 4	
	DB		Operator, 3	
	DW		(salInstr)	
	DW		(sarInstr)	
	DW		(sbbInstr)	
	DB		operator, 4	
	DW		(shlInstr)	
	DW		(shrInstr)	
	DB		lmlowReg, 6	
	DW		(smiInstr)	
	DB		lmlowReg, 4	
	DB		FPUReg, 0	
	DB		FPUReg, 1	
	DB		FPUReg, 2	
	DB		FPUReg, 3	
	DB		FPUReg, 4	
	DB		FPUReg, 5	
	DB		FPUReg, 6	
	DB		FPUReg, 7	
	DW		(stcInstr)	
	DW		(stdInstr)	
	DW		(stiInstr)	
	DW		(strInstr)	
	DW		(subInstr)	
	DB		TestReg, 0	
	DB		TestReg, 1	
	DB		TestReg, 2	
	DB		TestReg, 3	
	DB		TestReg, 4	
	DB		TestReg, 5	
	DB		TestReg, 6	
	DB		TestReg, 7	
	DW		(ud2Instr)	
	DW		(xorInstr)	
EVEN 2
Keyword4:
	DW	000,001,002,013,021,028,048,048,050,060,065,065,073,076,078,081,087,087,112,132,134,136,139,141,155,165,175
	DW	Keyword4High, Keyword4Desc


Keyword4a:
	DW		0x3639	;arpl low
Keyword4b:
	DW		0x75f1	;byte low
Keyword4c:
	DW		0x547b	;call low
	DW		0x0cbd	;cdqe low
	DW		0xbb97	;clts low
	DW		0xaebc	;cmps low
	DW		0xffab	;cr10 low
	DW		0x6a08	;cr11 low
	DW		0x9e87	;cr12 low
	DW		0xcf3d	;cr13 low
	DW		0x3bb2	;cr14 low
	DW		0x3647	;cr15 low
	DW		0x4071	;cwde low
Keyword4d:
	DW		0xc625	;dppd low
	DW		0x22ce	;dpps low
	DW		0x3f48	;dr10 low
	DW		0x6ef2	;dr11 low
	DW		0x5e64	;dr12 low
	DW		0xcbc7	;dr13 low
	DW		0xfb51	;dr14 low
	DW		0xaaeb	;dr15 low
Keyword4e:
	DW		0x9730	;echo low
	DW		0xcb5e	;else low
	DW		0x24ca	;emms low
	DW		0xcb79	;endm low
	DW		0xc68c	;endp low
	DW		0x8a9d	;ends low
	DW		0x3bc8	;even low
Keyword4f:
	DW		0xc486	;fabs low
	DW		0xe6c7	;fadd low
	DW		0x581a	;fbld low
	DW		0xf862	;fchs low
	DW		0x5068	;fcom low
	DW		0xa912	;fcos low
	DW		0xff47	;fdiv low
	DW		0xd982	;feni low
	DW		0x3d77	;fild low
	DW		0x840b	;fist low
	DW		0x9e6b	;fld1 low
	DW		0xa346	;fldz low
	DW		0xb481	;fmul low
	DW		0x1749	;fnop low
	DW		0x0439	;fsin low
	DW		0x36d9	;fstp low
	DW		0x3a72	;fsub low
	DW		0x62f5	;ftst low
	DW		0xaa15	;fxam low
	DW		0xb70d	;fxch low
Keyword4g:
Keyword4h:
	DW		0xb420	;halt low
	DW		0x029e	;high low
Keyword4i:
	DW		0x147b	;ibts low
	DW		0xbc71	;idiv low
	DW		0xbb9c	;imul low
	DW		0x9f33	;insb low
	DW		0xfe1f	;insd low
	DW		0xdeed	;insw low
	DW		0xd3d2	;into low
	DW		0x09f4	;invd low
	DW		0x633a	;iret low
	DW		0x720f	;irps low
Keyword4j:
	DW		0x1446	;jcxz low
	DW		0xf796	;jnae low
	DW		0x8afc	;jnbe low
	DW		0x7d17	;jnge low
	DW		0x1ef1	;jnle low
Keyword4k:
Keyword4l:
	DW		0x04d1	;lahf low
	DW		0x4bce	;lgdt low
	DW		0xe038	;lidt low
	DW		0x116d	;lldt low
	DW		0x1c7d	;lmsw low
	DW		0xe3c6	;lock low
	DW		0x4ad1	;lods low
	DW		0x6526	;loop low
Keyword4m:
	DW		0x51a1	;movd low
	DW		0x107f	;movq low
	DW		0x7153	;movs low
Keyword4n:
	DW		0x0ae7	;near low
	DW		0x9cb8	;none low
Keyword4o:
	DW		0x020c	;orpd low
	DW		0xe6e7	;orps low
	DW		0x9cd0	;outs low
Keyword4p:
	DW		0xee29	;pand low
	DW		0x44d1	;popa low
	DW		0xb05e	;popf low
	DW		0xcc09	;proc low
	DW		0xc5b2	;push low
	DW		0x8e74	;pxor low
Keyword4q:
Keyword4r:
	DW		0xcc3a	;r10b low
	DW		0x690f	;r10d low
	DW		0x49fd	;r10w low
	DW		0xb1d9	;r11b low
	DW		0xd0f5	;r11d low
	DW		0x341e	;r11w low
	DW		0x4481	;r12b low
	DW		0x25ad	;r12d low
	DW		0x055f	;r12w low
	DW		0xd35b	;r13b low
	DW		0x0ae9	;r13d low
	DW		0x569c	;r13w low
	DW		0xbe55	;r14b low
	DW		0x472f	;r14d low
	DW		0x67dd	;r14w low
	DW		0x15f1	;r15b low
	DW		0xb0c4	;r15d low
	DW		0x9036	;r15w low
	DW		0xbd7e	;repe low
	DW		0x15be	;repz low
	DW		0x48ec	;retd low
	DW		0x29c0	;retf low
	DW		0xa1f2	;retn low
	DW		0xcd2b	;retq low
	DW		0x3451	;retw low
Keyword4s:
	DW		0xb9f1	;sahf low
	DW		0x3fd4	;scas low
	DW		0xeae9	;seta low
	DW		0x8630	;setb low
	DW		0x8bc5	;setc low
	DW		0x2ef0	;sete low
	DW		0x4fdc	;setg low
	DW		0xf778	;setl low
	DW		0xc7ee	;seto low
	DW		0xab37	;setp low
	DW		0x9ba1	;sets low
	DW		0x0e02	;setz low
	DW		0x8cc1	;sgdt low
	DW		0x3866	;shld low
	DW		0x1a12	;shrd low
	DW		0x8b50	;sidt low
	DW		0xe427	;size low
	DW		0x6854	;sldt low
	DW		0x3b3e	;smsw low
	DW		0xb476	;stos low
Keyword4t:
	DW		0xa142	;test low
	DW		0x026f	;type low
Keyword4u:
	DW		0x22ef	;umov low
	DW		0x382b	;uses low
Keyword4v:
	DW		0x782e	;verr low
	DW		0xed8d	;verw low
	DW		0xc0eb	;vpor low
Keyword4w:
	DW		0x121d	;wait low
	DW		0xe4e9	;word low
Keyword4x:
	DW		0x1b51	;xadd low
	DW		0x7b53	;xbts low
	DW		0xd189	;xchg low
	DW		0xb84d	;xlat low
	DW		0x34f9	;xmm0 low
	DW		0xa15a	;xmm1 low
	DW		0x91cc	;xmm2 low
	DW		0xc076	;xmm3 low
	DW		0x78d2	;xmm4 low
	DW		0x6543	;xmm5 low
	DW		0x55d5	;xmm6 low
	DW		0x046f	;xmm7 low
	DW		0xbccb	;xmm8 low
	DW		0x2968	;xmm9 low
Keyword4y:
	DW		0x5748	;ymm0 low
	DW		0x5abd	;ymm1 low
	DW		0x6a2b	;ymm2 low
	DW		0x3b91	;ymm3 low
	DW		0x0b07	;ymm4 low
	DW		0x9ea4	;ymm5 low
	DW		0xae32	;ymm6 low
	DW		0xff88	;ymm7 low
	DW		0xcf1e	;ymm8 low
	DW		0xd28f	;ymm9 low
Keyword4z:
	DW		0xf42a	;zmm0 low
	DW		0xa590	;zmm1 low
	DW		0x9506	;zmm2 low
	DW		0x8897	;zmm3 low
	DW		0x3033	;zmm4 low
	DW		0x6189	;zmm5 low
	DW		0x511f	;zmm6 low
	DW		0xc4bc	;zmm7 low
	DW		0x7c18	;zmm8 low
	DW		0x2da2	;zmm9 low


Keyword4High:
	DW		0x843b	;arpl high
	DW		0x1cd0	;byte high
	DW		0x07ee	;call high
	DW		0xdc3c	;cdqe high
	DW		0x0dd6	;clts high
	DW		0xd4a1	;cmps high
	DW		0x97bb	;cr10 high
	DW		0x09df	;cr11 high
	DW		0x79b5	;cr12 high
	DW		0xe0bc	;cr13 high
	DW		0x90d6	;cr14 high
	DW		0x1dde	;cr15 high
	DW		0xa75a	;cwde high
	DW		0x47e9	;dppd high
	DW		0x2a34	;dpps high
	DW		0x795d	;dr10 high
	DW		0xe054	;dr11 high
	DW		0x9753	;dr12 high
	DW		0x0937	;dr13 high
	DW		0x7e30	;dr14 high
	DW		0xe739	;dr15 high
	DW		0x8e25	;echo high
	DW		0xbab0	;else high
	DW		0x6e47	;emms high
	DW		0x9870	;endm high
	DW		0x1578	;endp high
	DW		0x4d10	;ends high
	DW		0x3861	;even high
	DW		0x6a4f	;fabs high
	DW		0xbfc6	;fadd high
	DW		0x299d	;fbld high
	DW		0x9324	;fchs high
	DW		0xfa52	;fcom high
	DW		0x0730	;fcos high
	DW		0xfc9e	;fdiv high
	DW		0xe0a9	;feni high
	DW		0x790c	;fild high
	DW		0xffbb	;fist high
	DW		0x92b9	;fld1 high
	DW		0x9ad4	;fldz high
	DW		0xebde	;fmul high
	DW		0x926c	;fnop high
	DW		0x4a26	;fsin high
	DW		0x1e72	;fstp high
	DW		0x845d	;fsub high
	DW		0x57f8	;ftst high
	DW		0xdb93	;fxam high
	DW		0x3217	;fxch high
	DW		0xc0a1	;halt high
	DW		0x0b71	;high high
	DW		0x5ac3	;ibts high
	DW		0xd8fe	;idiv high
	DW		0xc608	;imul high
	DW		0x7145	;insb high
	DW		0x9f4b	;insd high
	DW		0xf5fb	;insw high
	DW		0x75ee	;into high
	DW		0x3e04	;invd high
	DW		0xb96e	;iret high
	DW		0x2289	;irps high
	DW		0x0ed0	;jcxz high
	DW		0x1384	;jnae high
	DW		0x0329	;jnbe high
	DW		0xa266	;jnge high
	DW		0xd6a9	;jnle high
	DW		0xc27a	;lahf high
	DW		0x7791	;lgdt high
	DW		0x38bd	;lidt high
	DW		0x964e	;lldt high
	DW		0x15c7	;lmsw high
	DW		0x89fd	;lock high
	DW		0x838a	;lods high
	DW		0xaf2d	;loop high
	DW		0x59c7	;movd high
	DW		0xdd79	;movq high
	DW		0x3377	;movs high
	DW		0x1360	;near high
	DW		0xab5e	;none high
	DW		0x98f2	;orpd high
	DW		0xf52f	;orps high
	DW		0x54f7	;outs high
	DW		0x2a94	;pand high
	DW		0xf4ac	;popa high
	DW		0x84c6	;popf high
	DW		0x6581	;proc high
	DW		0xc761	;push high
	DW		0xd021	;pxor high
	DW		0xa6b2	;r10b high
	DW		0x4fd1	;r10d high
	DW		0x2561	;r10w high
	DW		0xcf24	;r11b high
	DW		0x212a	;r11d high
	DW		0x4cf7	;r11w high
	DW		0xd152	;r12b high
	DW		0x3f5c	;r12d high
	DW		0x55ec	;r12w high
	DW		0xfd12	;r13b high
	DW		0x3b1e	;r13d high
	DW		0x7ec1	;r13w high
	DW		0xf008	;r14b high
	DW		0x0d6a	;r14d high
	DW		0x67da	;r14w high
	DW		0x4546	;r15b high
	DW		0xac25	;r15d high
	DW		0xc695	;r15w high
	DW		0x3d99	;repe high
	DW		0x59f2	;repz high
	DW		0x2ef2	;retd high
	DW		0xc0fc	;retf high
	DW		0xce27	;retn high
	DW		0xad21	;retq high
	DW		0x5043	;retw high
	DW		0x0608	;sahf high
	DW		0x57f9	;scas high
	DW		0x4537	;seta high
	DW		0x2631	;setb high
	DW		0xab39	;setc high
	DW		0x425a	;sete high
	DW		0xac54	;setg high
	DW		0xd588	;setl high
	DW		0xa28f	;seto high
	DW		0xc189	;setp high
	DW		0xb68e	;sets high
	DW		0x28ea	;setz high
	DW		0x0085	;sgdt high
	DW		0xb500	;shld high
	DW		0xa020	;shrd high
	DW		0xb160	;sidt high
	DW		0x0e5e	;size high
	DW		0x5551	;sldt high
	DW		0x95ac	;smsw high
	DW		0x08c2	;stos high
	DW		0x8057	;test high
	DW		0x1c2f	;type high
	DW		0xa757	;umov high
	DW		0x4c8a	;uses high
	DW		0xee94	;verr high
	DW		0x70f0	;verw high
	DW		0xe69f	;vpor high
	DW		0x6745	;wait high
	DW		0xd95a	;word high
	DW		0x77e0	;xadd high
	DW		0x715a	;xbts high
	DW		0x41d8	;xchg high
	DW		0x1c7c	;xlat high
	DW		0xcc2a	;xmm0 high
	DW		0x524e	;xmm1 high
	DW		0x2549	;xmm2 high
	DW		0xbc40	;xmm3 high
	DW		0xc59c	;xmm4 high
	DW		0x5523	;xmm5 high
	DW		0x2224	;xmm6 high
	DW		0xbb2d	;xmm7 high
	DW		0xc2f1	;xmm8 high
	DW		0x5c95	;xmm9 high
	DW		0x50e0	;ymm0 high
	DW		0xdde8	;ymm1 high
	DW		0xaaef	;ymm2 high
	DW		0x33e6	;ymm3 high
	DW		0x44e1	;ymm4 high
	DW		0xda85	;ymm5 high
	DW		0xad82	;ymm6 high
	DW		0x348b	;ymm7 high
	DW		0x438c	;ymm8 high
	DW		0xd333	;ymm9 high
	DW		0x1b49	;zmm0 high
	DW		0x8240	;zmm1 high
	DW		0xf547	;zmm2 high
	DW		0x65f8	;zmm3 high
	DW		0x1c24	;zmm4 high
	DW		0x852d	;zmm5 high
	DW		0xf22a	;zmm6 high
	DW		0x6c4e	;zmm7 high
	DW		0x1592	;zmm8 high
	DW		0x8c9b	;zmm9 high


Keyword4Desc:
	DW		(arplInstr)	
	DB		datatype, 1	
	DW		(callInstr)	
	DW		(cdqeInstr)	
	DW		(cltsInstr)	
	DW		(cmpsInstr)	
	DB		CtrlReg64, 2	
	DB		CtrlReg64, 3	
	DB		CtrlReg64, 4	
	DB		CtrlReg64, 5	
	DB		CtrlReg64, 6	
	DB		CtrlReg64, 7	
	DW		(cwdeInstr)	
	DW		(dppdInstr)	
	DW		(dppsInstr)	
	DB		DbgReg64, 2	
	DB		DbgReg64, 3	
	DB		DbgReg64, 4	
	DB		DbgReg64, 5	
	DB		DbgReg64, 6	
	DB		DbgReg64, 7	
	DW		(EchoMacro)	
	DW		(ElseDirective)	
	DW		(emmsInstr)	
	DW		(EndMDirective)	
	DW		(EndPDirective)	
	DW		(EndSDirective)	
	DW		(AlignDirective)	
	DW		(fabsInstr)	
	DW		(faddInstr)	
	DW		(fbldInstr)	
	DW		(fchsInstr)	
	DW		(fcomInstr)	
	DW		(fcosInstr)	
	DW		(fdivInstr)	
	DW		(feniInstr)	
	DW		(fildInstr)	
	DW		(fistInstr)	
	DW		(fld1Instr)	
	DW		(fldzInstr)	
	DW		(fmulInstr)	
	DW		(fnopInstr)	
	DW		(fsinInstr)	
	DW		(fstpInstr)	
	DW		(fsubInstr)	
	DW		(ftstInstr)	
	DW		(fxamInstr)	
	DW		(fxchInstr)	
	DW		(HaltMacro)	
	DB		operator, 5	
	DW		(ibtsInstr)	
	DW		(idivInstr)	
	DW		(imulInstr)	
	DW		(insbInstr)	
	DW		(insdInstr)	
	DW		(inswInstr)	
	DW		(intoInstr)	
	DW		(invdInstr)	
	DW		(iretInstr)	
	DW		(IRPSMacro)	
	DW		(jcxzInstr)	
	DW		(jbInstr)	
	DW		(jaInstr)	
	DW		(jlInstr)	
	DW		(jgInstr)	
	DW		(lahfInstr)	
	DW		(lgdtInstr)	
	DW		(lidtInstr)	
	DW		(lldtInstr)	
	DW		(lmswInstr)	
	DW		(lockInstr)	
	DW		(lodsInstr)	
	DW		(loopInstr)	
	DW		(movdInstr)	
	DW		(movqInstr)	
	DW		(movsInstr)	
	DB		distspec, 2	
	DB		options, 0	
	DW		(orpdInstr)	
	DW		(orpsInstr)	
	DW		(outsInstr)	
	DW		(pandInstr)	
	DW		(popaInstr)	
	DW		(popfInstr)	
	DW		(ProcDirective)	
	DW		(pushInstr)	
	DW		(pxorInstr)	
	DB		LMReg8, 2	
	DB		LMReg32, 2	
	DB		LMReg16, 2	
	DB		LMReg8, 3	
	DB		LMReg32, 3	
	DB		LMReg16, 3	
	DB		LMReg8, 4	
	DB		LMReg32, 4	
	DB		LMReg16, 4	
	DB		LMReg8, 5	
	DB		LMReg32, 5	
	DB		LMReg16, 5	
	DB		LMReg8, 6	
	DB		LMReg32, 6	
	DB		LMReg16, 6	
	DB		LMReg8, 7	
	DB		LMReg32, 7	
	DB		LMReg16, 7	
	DW		(repeInstr)	
	DW		(repzInstr)	
	DW		(retdInstr)	
	DW		(retfInstr)	
	DW		(retnInstr)	
	DW		(retqInstr)	
	DW		(retwInstr)	
	DW		(sahfInstr)	
	DW		(scasInstr)	
	DW		(setaInstr)	
	DW		(setbInstr)	
	DW		(setcInstr)	
	DW		(seteInstr)	
	DW		(setgInstr)	
	DW		(setlInstr)	
	DW		(setoInstr)	
	DW		(setpInstr)	
	DW		(setsInstr)	
	DW		(setzInstr)	
	DW		(sgdtInstr)	
	DW		(shldInstr)	
	DW		(shrdInstr)	
	DW		(sidtInstr)	
	DB		Operator, 6	
	DW		(sldtInstr)	
	DW		(smswInstr)	
	DW		(stosInstr)	
	DW		(testInstr)	
	DB		Operator, 7	
	DW		(umovInstr)	
	DB		options, 12	
	DW		(verrInstr)	
	DW		(verwInstr)	
	DW		(vporInstr)	
	DW		(waitInstr)	
	DB		datatype, 2	
	DW		(xaddInstr)	
	DW		(xbtsInstr)	
	DW		(xchgInstr)	
	DW		(xlatInstr)	
	DB		sseReg, 0	
	DB		sseReg, 1	
	DB		sseReg, 2	
	DB		sseReg, 3	
	DB		sseReg, 4	
	DB		sseReg, 5	
	DB		sseReg, 6	
	DB		sseReg, 7	
	DB		sseReg, 8	
	DB		sseReg, 9	
	DB		avxReg, 0	
	DB		avxReg, 1	
	DB		avxReg, 2	
	DB		avxReg, 3	
	DB		avxReg, 4	
	DB		avxReg, 5	
	DB		avxReg, 6	
	DB		avxReg, 7	
	DB		avxReg, 8	
	DB		avxReg, 9	
	DB		avx512Reg, 0	
	DB		avx512Reg, 1	
	DB		avx512Reg, 2	
	DB		avx512Reg, 3	
	DB		avx512Reg, 4	
	DB		avx512Reg, 5	
	DB		avx512Reg, 6	
	DB		avx512Reg, 7	
	DB		avx512Reg, 8	
	DB		avx512Reg, 9	
EVEN 2
Keyword5:
	DW	000,007,010,029,034,039,073,074,074,078,079,079,090,111,111,115,161,162,173,210,212,215,223,224,250,272,294
	DW	Keyword5High, Keyword5Desc


Keyword5a:
	DW		0x8132	;addpd low
	DW		0x29f2	;addps low
	DW		0x5870	;addsd low
	DW		0xc01c	;addss low
	DW		0x1dce	;align low
	DW		0x2d7d	;andpd low
	DW		0xc996	;andps low
Keyword5b:
	DW		0xe01c	;basic low
	DW		0x7fae	;bound low
	DW		0x23e5	;bswap low
Keyword5c:
	DW		0xd337	;callf low
	DW		0x1f49	;cmova low
	DW		0x2fdf	;cmovb low
	DW		0x222a	;cmovc low
	DW		0xdb50	;cmove low
	DW		0x7e65	;cmovg low
	DW		0x02d8	;cmovl low
	DW		0xf657	;cmovo low
	DW		0x5e97	;cmovp low
	DW		0x1286	;cmovs low
	DW		0xb789	;cmovz low
	DW		0xfa9f	;cmppd low
	DW		0x1e74	;cmpps low
	DW		0x6eeb	;cmpsb low
	DW		0xcbde	;cmpsd low
	DW		0x4e19	;cmpsq low
	DW		0x737a	;cmpss low
	DW		0x2f35	;cmpsw low
	DW		0x5fc2	;cpuid low
Keyword5d:
	DW		0x9caa	;divpd low
	DW		0x346a	;divps low
	DW		0xe1c0	;divsd low
	DW		0x052b	;divss low
	DW		0xa72c	;dword low
Keyword5e:
	DW		0x88ac	;endif low
	DW		0xb0ad	;enter low
	DW		0x7d59	;exitm low
	DW		0x964c	;extrn low
	DW		0xfa95	;extrq low
Keyword5f:
	DW		0xebc9	;f2xm1 low
	DW		0xfd58	;faddp low
	DW		0xaf26	;fbstp low
	DW		0x5799	;fclex low
	DW		0x337c	;fcomi low
	DW		0xfa90	;fcomp low
	DW		0x4c9e	;fdisi low
	DW		0x2661	;fdivp low
	DW		0x0b66	;fdivr low
	DW		0x31f2	;femms low
	DW		0x7bf8	;ffree low
	DW		0x58ca	;fiadd low
	DW		0x0a1b	;ficom low
	DW		0xab73	;fidiv low
	DW		0xd223	;fimul low
	DW		0xa5b0	;finit low
	DW		0x8693	;fistp low
	DW		0xa418	;fisub low
	DW		0x4eb9	;fldcw low
	DW		0x50ca	;fldpi low
	DW		0x4d84	;fmulp low
	DW		0xc91a	;fneni low
	DW		0xaa74	;fprem low
	DW		0x20fa	;fptan low
	DW		0xa29d	;fsave low
	DW		0x412e	;fsqrt low
	DW		0xef5f	;fstcw low
	DW		0xfd0e	;fstsw low
	DW		0x0c80	;fsubp low
	DW		0x6dac	;fsubr low
	DW		0x8cdf	;fucom low
	DW		0x8d2d	;fwait low
	DW		0xf1d1	;fword low
	DW		0xd284	;fyl2x low
Keyword5g:
	DW		0x7b83	;group low
Keyword5h:
Keyword5i:
	DW		0x85c9	;ifdef low
	DW		0x2206	;iretd low
	DW		0x63d8	;iretq low
	DW		0x02f4	;iretw low
Keyword5j:
	DW		0xaef3	;jecxz low
Keyword5k:
Keyword5l:
	DW		0x2593	;label low
	DW		0x82a7	;lddqu low
	DW		0xa43b	;leave low
	DW		0x6f09	;local low
	DW		0xfddf	;lodsb low
	DW		0x9cf3	;lodsd low
	DW		0x1934	;lodsq low
	DW		0xbc01	;lodsw low
	DW		0x3d4f	;loopd low
	DW		0xa8ec	;loope low
	DW		0x002c	;loopz low
Keyword5m:
	DW		0x1c89	;macro low
	DW		0x3026	;maxpd low
	DW		0xd4cd	;maxps low
	DW		0xa54f	;maxsd low
	DW		0x41a4	;maxss low
	DW		0xf369	;minpd low
	DW		0x1782	;minps low
	DW		0xdafb	;minsd low
	DW		0x0307	;minss low
	DW		0x26f1	;movsb low
	DW		0xcfef	;movsd low
	DW		0x0603	;movsq low
	DW		0x672f	;movss low
	DW		0xa336	;movsw low
	DW		0x1b92	;movsx low
	DW		0xc259	;movzx low
	DW		0x2076	;mulpd low
	DW		0x88b6	;mulps low
	DW		0x1137	;mulsd low
	DW		0xf5dc	;mulss low
	DW		0xbdce	;mwait low
Keyword5n:
Keyword5o:
	DW		0x15aa	;outsb low
	DW		0xb09f	;outsd low
	DW		0xdc46	;outsw low
	DW		0xea92	;oword low
Keyword5p:
	DW		0x4192	;pabsb low
	DW		0xe4a7	;pabsd low
	DW		0xc455	;pabsw low
	DW		0xd89a	;paddb low
	DW		0x3184	;paddd low
	DW		0xf868	;paddq low
	DW		0x5d5d	;paddw low
	DW		0x5d4c	;pandn low
	DW		0x8b13	;pause low
	DW		0x9d6b	;paveb low
	DW		0x0781	;pavgb low
	DW		0x465f	;pavgw low
	DW		0x173e	;pf2id low
	DW		0x37cc	;pf2iw low
	DW		0x2e90	;pfacc low
	DW		0x4f76	;pfadd low
	DW		0x7f34	;pfmax low
	DW		0x406d	;pfmin low
	DW		0x61b7	;pfmul low
	DW		0xa714	;pfrcp low
	DW		0x93c3	;pfsub low
	DW		0x3b33	;pi2fd low
	DW		0x1bc1	;pi2fw low
	DW		0x4eae	;pmagw low
	DW		0xb7a6	;pmvzb low
	DW		0xbafd	;popad low
	DW		0x2f94	;popfd low
	DW		0xf61c	;popfq low
	DW		0x0f66	;popfw low
	DW		0x07c6	;pslld low
	DW		0xde4e	;psllq low
	DW		0x7b7b	;psllw low
	DW		0x0f96	;psrad low
	DW		0x634f	;psraw low
	DW		0xd65d	;psrld low
	DW		0x539a	;psrlq low
	DW		0xaae0	;psrlw low
	DW		0x06e7	;psubb low
	DW		0x67cb	;psubd low
	DW		0xe20c	;psubq low
	DW		0x4739	;psubw low
	DW		0xb129	;ptest low
	DW		0x7708	;pusha low
	DW		0x26b2	;pushd low
	DW		0x479e	;pushf low
	DW		0x8941	;pword low
Keyword5q:
	DW		0x862e	;qword low
Keyword5r:
	DW		0xf2e3	;radix low
	DW		0x3da3	;rcpps low
	DW		0xa8ca	;rcpss low
	DW		0x1b74	;rdmsr low
	DW		0xbee7	;rdpmc low
	DW		0x163b	;rdtsc low
	DW		0x86d3	;repne low
	DW		0xb645	;repnz low
	DW		0xab4e	;retfd low
	DW		0x2e89	;retfq low
	DW		0xc797	;retfw low
Keyword5s:
	DW		0xdf10	;scasb low
	DW		0x7a25	;scasd low
	DW		0xffe2	;scasq low
	DW		0x9ece	;scasw low
	DW		0xd6e3	;segcs low
	DW		0xe7a2	;segds low
	DW		0xd450	;seges low
	DW		0x2108	;segfs low
	DW		0x4fdc	;seggs low
	DW		0xc4b2	;segss low
	DW		0xc877	;setae low
	DW		0xc547	;setbe low
	DW		0x0edd	;setge low
	DW		0xb594	;setle low
	DW		0xb727	;setna low
	DW		0xdbfe	;setnb low
	DW		0xd60b	;setnc low
	DW		0x733e	;setne low
	DW		0x1212	;setng low
	DW		0xaab6	;setnl low
	DW		0x9a20	;setno low
	DW		0xf6f9	;setnp low
	DW		0xc66f	;setns low
	DW		0x53cc	;setnz low
	DW		0x89e5	;setpe low
	DW		0x60fb	;setpo low
	DW		0x2bc0	;short low
	DW		0x0626	;stack low
	DW		0x265f	;stosb low
	DW		0x836a	;stosd low
	DW		0x4a86	;stosq low
	DW		0xa398	;stosw low
	DW		0x6056	;struc low
	DW		0x312e	;subpd low
	DW		0x11dc	;subps low
	DW		0x006f	;subsd low
	DW		0xe484	;subss low
Keyword5t:
	DW		0xdb0a	;tbyte low
	DW		0x5efd	;tword low
Keyword5u:
	DW		0x9adc	;use16 low
	DW		0x3c47	;use32 low
	DW		0x6e99	;use64 low
Keyword5v:
	DW		0x16cc	;vdppd low
	DW		0xf227	;vdpps low
	DW		0xb5eb	;vmovd low
	DW		0xf435	;vmovq low
	DW		0x8e86	;vorpd low
	DW		0x2646	;vorps low
	DW		0x2332	;vpand low
	DW		0x8931	;vpxor low
Keyword5w:
	DW		0xaab0	;wrmsr low
Keyword5x:
	DW		0x4c14	;xlatb low
	DW		0xf671	;xmm10 low
	DW		0x63d2	;xmm11 low
	DW		0x975d	;xmm12 low
	DW		0xc6e7	;xmm13 low
	DW		0x3268	;xmm14 low
	DW		0x3f9d	;xmm15 low
	DW		0x5344	;xmm16 low
	DW		0x02fe	;xmm17 low
	DW		0x7e43	;xmm18 low
	DW		0xebe0	;xmm19 low
	DW		0xc730	;xmm20 low
	DW		0x968a	;xmm21 low
	DW		0xa61c	;xmm22 low
	DW		0x4990	;xmm23 low
	DW		0x0329	;xmm24 low
	DW		0x5293	;xmm25 low
	DW		0x6205	;xmm26 low
	DW		0xf7a6	;xmm27 low
	DW		0x4f02	;xmm28 low
	DW		0x1eb8	;xmm29 low
	DW		0x94f3	;xmm30 low
	DW		0x8962	;xmm31 low
	DW		0x92ea	;xorpd low
	DW		0x3a2a	;xorps low
	DW		0xbc56	;xsave low
Keyword5y:
	DW		0x467d	;ymm10 low
	DW		0x17c7	;ymm11 low
	DW		0x7b1e	;ymm12 low
	DW		0x76eb	;ymm13 low
	DW		0x8264	;ymm14 low
	DW		0xd3de	;ymm15 low
	DW		0x2751	;ymm16 low
	DW		0xb2f2	;ymm17 low
	DW		0xce4f	;ymm18 low
	DW		0x9ff5	;ymm19 low
	DW		0xb325	;ymm20 low
	DW		0x2686	;ymm21 low
	DW		0x1610	;ymm22 low
	DW		0x47aa	;ymm23 low
	DW		0xcfa2	;ymm24 low
	DW		0xe29f	;ymm25 low
	DW		0xd209	;ymm26 low
	DW		0x83b3	;ymm27 low
	DW		0x3b17	;ymm28 low
	DW		0xaeb4	;ymm29 low
	DW		0x24ff	;ymm30 low
	DW		0x7545	;ymm31 low
Keyword5z:
	DW		0xd3db	;zmm10 low
	DW		0x8261	;zmm11 low
	DW		0xb2f7	;zmm12 low
	DW		0x2754	;zmm13 low
	DW		0x17c2	;zmm14 low
	DW		0x4678	;zmm15 low
	DW		0x76ee	;zmm16 low
	DW		0x6b7f	;zmm17 low
	DW		0x5be9	;zmm18 low
	DW		0x0a53	;zmm19 low
	DW		0xe29a	;zmm20 low
	DW		0xff0b	;zmm21 low
	DW		0x83b6	;zmm22 low
	DW		0xd20c	;zmm23 low
	DW		0x2683	;zmm24 low
	DW		0xb320	;zmm25 low
	DW		0x47af	;zmm26 low
	DW		0x1615	;zmm27 low
	DW		0x6aa8	;zmm28 low
	DW		0x0605	;zmm29 low
	DW		0xd352	;zmm30 low
	DW		0xcec3	;zmm31 low


Keyword5High:
	DW		0x0e4f	;addpd high
	DW		0x6a24	;addps high
	DW		0x9480	;addsd high
	DW		0xd632	;addss high
	DW		0x8485	;align high
	DW		0x6844	;andpd high
	DW		0x0599	;andps high
	DW		0x56c9	;basic high
	DW		0xecdc	;bound high
	DW		0x22c4	;bswap high
	DW		0xfa08	;callf high
	DW		0x91bc	;cmova high
	DW		0xe6bb	;cmovb high
	DW		0x6bb3	;cmovc high
	DW		0x96d1	;cmove high
	DW		0x7fb2	;cmovg high
	DW		0x0103	;cmovl high
	DW		0x7169	;cmovo high
	DW		0x1502	;cmovp high
	DW		0x4d6a	;cmovs high
	DW		0xf5d7	;cmovz high
	DW		0xe6c0	;cmppd high
	DW		0x8b1d	;cmpps high
	DW		0x16b8	;cmpsb high
	DW		0xffdb	;cmpsd high
	DW		0x7c08	;cmpsq high
	DW		0x8607	;cmpss high
	DW		0x9206	;cmpsw high
	DW		0xcaa8	;cpuid high
	DW		0x0e2e	;divpd high
	DW		0x6a45	;divps high
	DW		0x1e83	;divsd high
	DW		0x735e	;divss high
	DW		0x6799	;dword high
	DW		0x9efb	;endif high
	DW		0x34b2	;enter high
	DW		0xe01d	;exitm high
	DW		0x312e	;extrn high
	DW		0x5228	;extrq high
	DW		0xda72	;f2xm1 high
	DW		0xc505	;faddp high
	DW		0x837c	;fbstp high
	DW		0xc73d	;fclex high
	DW		0xeef4	;fcomi high
	DW		0x6491	;fcomp high
	DW		0x979f	;fdisi high
	DW		0x28fe	;fdivp high
	DW		0xcf46	;fdivr high
	DW		0xbc9f	;femms high
	DW		0x4e38	;ffree high
	DW		0xcaaa	;fiadd high
	DW		0xf8ba	;ficom high
	DW		0xcc24	;fidiv high
	DW		0x3bbf	;fimul high
	DW		0x6a6b	;finit high
	DW		0x594c	;fistp high
	DW		0x81d8	;fisub high
	DW		0x617b	;fldcw high
	DW		0xc8ad	;fldpi high
	DW		0x5358	;fmulp high
	DW		0xc47e	;fneni high
	DW		0x02a7	;fprem high
	DW		0xc979	;fptan high
	DW		0x1497	;fsave high
	DW		0xef0e	;fsqrt high
	DW		0x15ae	;fstcw high
	DW		0x5f6c	;fstsw high
	DW		0x998d	;fsubp high
	DW		0x7783	;fsubr high
	DW		0xac3a	;fucom high
	DW		0x7d44	;fwait high
	DW		0x0b82	;fword high
	DW		0x6176	;fyl2x high
	DW		0x358c	;group high
	DW		0x34b6	;ifdef high
	DW		0xfb6d	;iretd high
	DW		0x7fd3	;iretq high
	DW		0x91dd	;iretw high
	DW		0xd3ae	;jecxz high
	DW		0xe3f8	;label high
	DW		0x7b2d	;lddqu high
	DW		0xe55f	;leave high
	DW		0xbb62	;local high
	DW		0xcc8f	;lodsb high
	DW		0x2281	;lodsd high
	DW		0xa152	;lodsq high
	DW		0x4831	;lodsw high
	DW		0xef7a	;loopd high
	DW		0x711e	;loope high
	DW		0x1575	;loopz high
	DW		0xbb72	;macro high
	DW		0x5c32	;maxpd high
	DW		0x31ef	;maxps high
	DW		0xcf4b	;maxsd high
	DW		0xa296	;maxss high
	DW		0x2b4c	;minpd high
	DW		0x4691	;minps high
	DW		0xafaa	;minsd high
	DW		0x9bc4	;minss high
	DW		0xc8e4	;movsb high
	DW		0x2831	;movsd high
	DW		0xa254	;movsq high
	DW		0x4c5a	;movss high
	DW		0x4b37	;movsw high
	DW		0x32eb	;movsx high
	DW		0xd11f	;movzx high
	DW		0xcab1	;mulpd high
	DW		0xaeda	;mulps high
	DW		0xd3aa	;mulsd high
	DW		0xbe77	;mulss high
	DW		0x3662	;mwait high
	DW		0x523c	;outsb high
	DW		0xbb5f	;outsd high
	DW		0xd859	;outsw high
	DW		0xe088	;oword high
	DW		0x9aba	;pabsb high
	DW		0x73d9	;pabsd high
	DW		0x1969	;pabsw high
	DW		0x75ba	;paddb high
	DW		0x956f	;paddd high
	DW		0x1f0a	;paddq high
	DW		0xf669	;paddw high
	DW		0x782d	;pandn high
	DW		0x9bb8	;pause high
	DW		0xaf3b	;paveb high
	DW		0x9219	;pavgb high
	DW		0x16a7	;pavgw high
	DW		0x472a	;pf2id high
	DW		0x2d9a	;pf2iw high
	DW		0x4edf	;pfacc high
	DW		0xadcc	;pfadd high
	DW		0x23ae	;pfmax high
	DW		0x1fa3	;pfmin high
	DW		0xd6bb	;pfmul high
	DW		0xb484	;pfrcp high
	DW		0x9657	;pfsub high
	DW		0x3925	;pi2fd high
	DW		0x5395	;pi2fw high
	DW		0x6b56	;pmagw high
	DW		0xfebd	;pmvzb high
	DW		0x22f6	;popad high
	DW		0xb18f	;popfd high
	DW		0x265d	;popfq high
	DW		0xdb3f	;popfw high
	DW		0x8634	;pslld high
	DW		0x11e6	;psllq high
	DW		0xf885	;psllw high
	DW		0xbb41	;psrad high
	DW		0xd847	;psraw high
	DW		0x58b5	;psrld high
	DW		0xdb66	;psrlq high
	DW		0x2604	;psrlw high
	DW		0x14bc	;psubb high
	DW		0xfab2	;psubd high
	DW		0x7961	;psubq high
	DW		0x9002	;psubw high
	DW		0xbfa4	;ptest high
	DW		0x8179	;pusha high
	DW		0x1870	;pushd high
	DW		0xf67e	;pushf high
	DW		0xcc3d	;pword high
	DW		0x5fd1	;qword high
	DW		0xac3f	;radix high
	DW		0x2c63	;rcpps high
	DW		0xbf1a	;rcpss high
	DW		0x67db	;rdmsr high
	DW		0xf41f	;rdpmc high
	DW		0xf316	;rdtsc high
	DW		0xcaea	;repne high
	DW		0xbded	;repnz high
	DW		0xa67c	;retfd high
	DW		0x25af	;retfq high
	DW		0xc57a	;retfw high
	DW		0x5552	;scasb high
	DW		0xbc31	;scasd high
	DW		0x3fe2	;scasq high
	DW		0xd1ec	;scasw high
	DW		0x484a	;segcs high
	DW		0x5151	;segds high
	DW		0xf773	;seges high
	DW		0xe905	;segfs high
	DW		0x9b9b	;seggs high
	DW		0x0288	;segss high
	DW		0x934c	;setae high
	DW		0x822e	;setbe high
	DW		0x2b18	;setge high
	DW		0xfada	;setle high
	DW		0x45e3	;setna high
	DW		0x26e5	;setnb high
	DW		0xabed	;setnc high
	DW		0x428e	;setne high
	DW		0xac80	;setng high
	DW		0xd55c	;setnl high
	DW		0xa25b	;setno high
	DW		0xc15d	;setnp high
	DW		0xb65a	;setns high
	DW		0x283e	;setnz high
	DW		0xf2a3	;setpe high
	DW		0x1276	;setpo high
	DW		0xe0c6	;short high
	DW		0x020f	;stack high
	DW		0x6dd5	;stosb high
	DW		0x84b6	;stosd high
	DW		0x0ed3	;stosq high
	DW		0xee06	;stosw high
	DW		0x0440	;struc high
	DW		0xcd16	;subpd high
	DW		0xa7a6	;subps high
	DW		0xd40d	;subsd high
	DW		0xb9d0	;subss high
	DW		0xec49	;tbyte high
	DW		0xc8a1	;tword high
	DW		0x380c	;use16 high
	DW		0x0d57	;use32 high
	DW		0x457b	;use64 high
	DW		0x1edf	;vdppd high
	DW		0x7302	;vdpps high
	DW		0x07a8	;vmovd high
	DW		0x8316	;vmovq high
	DW		0xbc6b	;vorpd high
	DW		0xd800	;vorps high
	DW		0xd439	;vpand high
	DW		0x1bb3	;vpxor high
	DW		0xb226	;wrmsr high
	DW		0x26c5	;xlatb high
	DW		0xda32	;xmm10 high
	DW		0x4456	;xmm11 high
	DW		0x343c	;xmm12 high
	DW		0xad35	;xmm13 high
	DW		0xdd5f	;xmm14 high
	DW		0x5057	;xmm15 high
	DW		0x3351	;xmm16 high
	DW		0xaa58	;xmm17 high
	DW		0xd4e9	;xmm18 high
	DW		0x4a8d	;xmm19 high
	DW		0xc329	;xmm20 high
	DW		0x5a20	;xmm21 high
	DW		0x2d27	;xmm22 high
	DW		0x0025	;xmm23 high
	DW		0xc444	;xmm24 high
	DW		0x5d4d	;xmm25 high
	DW		0x2a4a	;xmm26 high
	DW		0xb42e	;xmm27 high
	DW		0xcdf2	;xmm28 high
	DW		0x54fb	;xmm29 high
	DW		0xe804	;xmm30 high
	DW		0x78bb	;xmm31 high
	DW		0x6a1e	;xorpd high
	DW		0x0e75	;xorps high
	DW		0x3f61	;xsave high
	DW		0x0add	;ymm10 high
	DW		0x93d4	;ymm11 high
	DW		0xf0d2	;ymm12 high
	DW		0x7dda	;ymm13 high
	DW		0x0db0	;ymm14 high
	DW		0x94b9	;ymm15 high
	DW		0xe4d3	;ymm16 high
	DW		0x7ab7	;ymm17 high
	DW		0x0406	;ymm18 high
	DW		0x9d0f	;ymm19 high
	DW		0x14ab	;ymm20 high
	DW		0x8acf	;ymm21 high
	DW		0xfdc8	;ymm22 high
	DW		0x64c1	;ymm23 high
	DW		0x3bc4	;ymm24 high
	DW		0x8da2	;ymm25 high
	DW		0xfaa5	;ymm26 high
	DW		0x63ac	;ymm27 high
	DW		0x1a70	;ymm28 high
	DW		0x8414	;ymm29 high
	DW		0x38eb	;ymm30 high
	DW		0xa1e2	;ymm31 high
	DW		0xa153	;zmm10 high
	DW		0x385a	;zmm11 high
	DW		0x4f5d	;zmm12 high
	DW		0xd139	;zmm13 high
	DW		0xa63e	;zmm14 high
	DW		0x3f37	;zmm15 high
	DW		0x4830	;zmm16 high
	DW		0xd88f	;zmm17 high
	DW		0xaf88	;zmm18 high
	DW		0x3681	;zmm19 high
	DW		0xb848	;zmm20 high
	DW		0x28f7	;zmm21 high
	DW		0x5646	;zmm22 high
	DW		0xcf4f	;zmm23 high
	DW		0xbf25	;zmm24 high
	DW		0x2141	;zmm25 high
	DW		0x512b	;zmm26 high
	DW		0xc822	;zmm27 high
	DW		0xb693	;zmm28 high
	DW		0x7629	;zmm29 high
	DW		0xd868	;zmm30 high
	DW		0x48d7	;zmm31 high


Keyword5Desc:
	DW		(addpdInstr)	
	DW		(addpsInstr)	
	DW		(addsdInstr)	
	DW		(addssInstr)	
	DW		(AlignDirective)	
	DW		(andpdInstr)	
	DW		(andpsInstr)	
	DB		Lang, 1	
	DW		(boundInstr)	
	DW		(bswapInstr)	
	DW		(callInstr)	
	DW		(cmovaInstr)	
	DW		(cmovbInstr)	
	DW		(cmovbInstr)	
	DW		(cmovzInstr)	
	DW		(cmovgInstr)	
	DW		(cmovlInstr)	
	DW		(cmovoInstr)	
	DW		(cmovpInstr)	
	DW		(cmovsInstr)	
	DW		(cmovzInstr)	
	DW		(cmppdInstr)	
	DW		(cmppsInstr)	
	DW		(cmpsbInstr)	
	DW		(cmpsdInstr)	
	DW		(cmpsqInstr)	
	DW		(cmpssInstr)	
	DW		(cmpswInstr)	
	DW		(cpuidInstr)	
	DW		(divpdInstr)	
	DW		(divpsInstr)	
	DW		(divsdInstr)	
	DW		(divssInstr)	
	DB		datatype, 3	
	DW		(EndIfDirective)	
	DW		(enterInstr)	
	DW		(ExitMDirective)	
	DW		(ExternDirective)	
	DW		(extrqInstr)	
	DW		(f2xm1Instr)	
	DW		(faddpInstr)	
	DW		(fbstpInstr)	
	DW		(fclexInstr)	
	DW		(fcomiInstr)	
	DW		(fcompInstr)	
	DW		(fdisiInstr)	
	DW		(fdivpInstr)	
	DW		(fdivrInstr)	
	DW		(femmsInstr)	
	DW		(ffreeInstr)	
	DW		(fiaddInstr)	
	DW		(ficomInstr)	
	DW		(fidivInstr)	
	DW		(fimulInstr)	
	DW		(finitInstr)	
	DW		(fistpInstr)	
	DW		(fisubInstr)	
	DW		(fldcwInstr)	
	DW		(fldpiInstr)	
	DW		(fmulpInstr)	
	DW		(fneniInstr)	
	DW		(fpremInstr)	
	DW		(fptanInstr)	
	DW		(fsaveInstr)	
	DW		(fsqrtInstr)	
	DW		(fstcwInstr)	
	DW		(fstswInstr)	
	DW		(fsubpInstr)	
	DW		(fsubrInstr)	
	DW		(fucomInstr)	
	DW		(waitInstr)	
	DB		datatype, 4	
	DW		(fyl2xInstr)	
	DW		(GroupDirective)	
	DW		(IfDefDirective)	
	DW		(iretdInstr)	
	DW		(iretqInstr)	
	DW		(iretwInstr)	
	DW		(jecxzInstr)	
	DW		(LabelDirective)	
	DW		(lddquInstr)	
	DW		(leaveInstr)	
	DW		(LocalDirective)	
	DW		(lodsbInstr)	
	DW		(lodsdInstr)	
	DW		(lodsqInstr)	
	DW		(lodswInstr)	
	DW		(loopdInstr)	
	DW		(loopzInstr)	
	DW		(loopzInstr)	
	DW		(MacroDirective)	
	DW		(maxpdInstr)	
	DW		(maxpsInstr)	
	DW		(maxsdInstr)	
	DW		(maxssInstr)	
	DW		(minpdInstr)	
	DW		(minpsInstr)	
	DW		(minsdInstr)	
	DW		(minssInstr)	
	DW		(movsbInstr)	
	DW		(movsdInstr)	
	DW		(movsqInstr)	
	DW		(movssInstr)	
	DW		(movswInstr)	
	DW		(movsxInstr)	
	DW		(movzxInstr)	
	DW		(mulpdInstr)	
	DW		(mulpsInstr)	
	DW		(mulsdInstr)	
	DW		(mulssInstr)	
	DW		(mwaitInstr)	
	DW		(outsbInstr)	
	DW		(outsdInstr)	
	DW		(outswInstr)	
	DB		datatype, 7	
	DW		(pabsbInstr)	
	DW		(pabsdInstr)	
	DW		(pabswInstr)	
	DW		(paddbInstr)	
	DW		(padddInstr)	
	DW		(paddqInstr)	
	DW		(paddwInstr)	
	DW		(pandnInstr)	
	DW		(pauseInstr)	
	DW		(pavebInstr)	
	DW		(pavgbInstr)	
	DW		(pavgwInstr)	
	DW		(pf2idInstr)	
	DW		(pf2iwInstr)	
	DW		(pfaccInstr)	
	DW		(pfaddInstr)	
	DW		(pfmaxInstr)	
	DW		(pfminInstr)	
	DW		(pfmulInstr)	
	DW		(pfrcpInstr)	
	DW		(pfsubInstr)	
	DW		(pi2fdInstr)	
	DW		(pi2fwInstr)	
	DW		(pmagwInstr)	
	DW		(pmvzbInstr)	
	DW		(popadInstr)	
	DW		(popfdInstr)	
	DW		(PopFQInstr)	
	DW		(PopFWInstr)	
	DW		(pslldInstr)	
	DW		(psllqInstr)	
	DW		(psllwInstr)	
	DW		(psradInstr)	
	DW		(psrawInstr)	
	DW		(psrldInstr)	
	DW		(psrlqInstr)	
	DW		(psrlwInstr)	
	DW		(psubbInstr)	
	DW		(psubdInstr)	
	DW		(psubqInstr)	
	DW		(psubwInstr)	
	DW		(ptestInstr)	
	DW		(pushaInstr)	
	DW		(pushdInstr)	
	DW		(pushfInstr)	
	DB		datatype, 4	
	DB		datatype, 5	
	DW		(RadixDirective)	
	DW		(rcppsInstr)	
	DW		(rcpssInstr)	
	DW		(rdmsrInstr)	
	DW		(rdpmcInstr)	
	DW		(rdtscInstr)	
	DW		(repneInstr)	
	DW		(repnzInstr)	
	DW		(retfdInstr)	
	DW		(retfqInstr)	
	DW		(retfwInstr)	
	DW		(scasbInstr)	
	DW		(scasdInstr)	
	DW		(scasqInstr)	
	DW		(scaswInstr)	
	DW		(segcsInstr)	
	DW		(segdsInstr)	
	DW		(segesInstr)	
	DW		(segfsInstr)	
	DW		(seggsInstr)	
	DW		(segssInstr)	
	DW		(setaeInstr)	
	DW		(setbeInstr)	
	DW		(setgeInstr)	
	DW		(setleInstr)	
	DW		(setnaInstr)	
	DW		(setnbInstr)	
	DW		(setncInstr)	
	DW		(setneInstr)	
	DW		(setngInstr)	
	DW		(setnlInstr)	
	DW		(setnoInstr)	
	DW		(setnpInstr)	
	DW		(setnsInstr)	
	DW		(setnzInstr)	
	DW		(setpeInstr)	
	DW		(setpoInstr)	
	DB		distspec, 1	
	DW		(StackDirective)	
	DW		(stosbInstr)	
	DW		(stosdInstr)	
	DW		(stosqInstr)	
	DW		(stoswInstr)	
	DW		(StrucDirective)	
	DW		(subpdInstr)	
	DW		(subpsInstr)	
	DW		(subsdInstr)	
	DW		(subssInstr)	
	DB		datatype, 6	
	DB		datatype, 6	
	DW		(Use16Directive)	
	DW		(Use32Directive)	
	DW		(Use64Directive)	
	DW		(vdppdInstr)	
	DW		(vdppsInstr)	
	DW		(vmovdInstr)	
	DW		(vmovqInstr)	
	DW		(vorpdInstr)	
	DW		(vorpsInstr)	
	DW		(vpandInstr)	
	DW		(vpxorInstr)	
	DW		(wrmsrInstr)	
	DW		(xlatInstr)	
	DB		sseReg, 10	
	DB		sseReg, 11	
	DB		sseReg, 12	
	DB		sseReg, 13	
	DB		sseReg, 14	
	DB		sseReg, 15	
	DB		sseReg, 16	
	DB		sseReg, 17	
	DB		sseReg, 18	
	DB		sseReg, 19	
	DB		sseReg, 20	
	DB		sseReg, 21	
	DB		sseReg, 22	
	DB		sseReg, 23	
	DB		sseReg, 24	
	DB		sseReg, 25	
	DB		sseReg, 26	
	DB		sseReg, 27	
	DB		sseReg, 28	
	DB		sseReg, 29	
	DB		sseReg, 30	
	DB		sseReg, 31	
	DW		(xorpdInstr)	
	DW		(xorpsInstr)	
	DW		(xsaveInstr)	
	DB		avxReg, 10	
	DB		avxReg, 11	
	DB		avxReg, 12	
	DB		avxReg, 13	
	DB		avxReg, 14	
	DB		avxReg, 15	
	DB		avxReg, 16	
	DB		avxReg, 17	
	DB		avxReg, 18	
	DB		avxReg, 19	
	DB		avxReg, 20	
	DB		avxReg, 21	
	DB		avxReg, 22	
	DB		avxReg, 23	
	DB		avxReg, 24	
	DB		avxReg, 25	
	DB		avxReg, 26	
	DB		avxReg, 27	
	DB		avxReg, 28	
	DB		avxReg, 29	
	DB		avxReg, 30	
	DB		avxReg, 31	
	DB		avx512Reg, 10	
	DB		avx512Reg, 11	
	DB		avx512Reg, 12	
	DB		avx512Reg, 13	
	DB		avx512Reg, 14	
	DB		avx512Reg, 15	
	DB		avx512Reg, 16	
	DB		avx512Reg, 17	
	DB		avx512Reg, 18	
	DB		avx512Reg, 19	
	DB		avx512Reg, 20	
	DB		avx512Reg, 21	
	DB		avx512Reg, 22	
	DB		avx512Reg, 23	
	DB		avx512Reg, 24	
	DB		avx512Reg, 25	
	DB		avx512Reg, 26	
	DB		avx512Reg, 27	
	DB		avx512Reg, 28	
	DB		avx512Reg, 29	
	DB		avx512Reg, 30	
	DB		avx512Reg, 31	
EVEN 2
Keyword6:
	DW	000,005,005,023,024,028,063,064,068,072,072,072,078,092,092,094,147,147,148,164,164,164,244,245,250,250,250
	DW	Keyword6High, Keyword6Desc


Keyword6a:
	DW		0x1738	;aesdec low
	DW		0xb71d	;aesenc low
	DW		0x1dba	;aesimc low
	DW		0xcad1	;andnpd low
	DW		0x6211	;andnps low
Keyword6b:
Keyword6c:
	DW		0xe06a	;cmovae low
	DW		0xd12b	;cmovbe low
	DW		0x82e8	;cmovge low
	DW		0x9d89	;cmovle low
	DW		0x3b12	;cmovna low
	DW		0x0b84	;cmovnb low
	DW		0x1615	;cmovnc low
	DW		0xff0b	;cmovne low
	DW		0x5a3e	;cmovng low
	DW		0x2683	;cmovnl low
	DW		0xd20c	;cmovno low
	DW		0x7acc	;cmovnp low
	DW		0x0671	;cmovns low
	DW		0x93d2	;cmovnz low
	DW		0xa1f8	;cmovpe low
	DW		0x48e6	;cmovpo low
	DW		0x6910	;comisd low
	DW		0xc1d0	;comiss low
Keyword6d:
	DW		0x74cd	;dqword low
Keyword6e:
	DW		0x4cbd	;elseif low
	DW		0x991e	;enterd low
	DW		0x9b00	;export low
	DW		0x608c	;extern low
Keyword6f:
	DW		0xab2a	;fcmovb low
	DW		0x5fa5	;fcmove low
	DW		0x4fc1	;fcmovu low
	DW		0x888e	;fcomip low
	DW		0x4314	;fcompp low
	DW		0xc3cc	;fdivrp low
	DW		0x03ff	;ffreep low
	DW		0x9779	;ficomp low
	DW		0x4587	;fidivr low
	DW		0x6163	;fisttp low
	DW		0x6074	;fisubr low
	DW		0x3f25	;fldenv low
	DW		0xfd34	;fldl2e low
	DW		0xc06d	;fldl2t low
	DW		0xf2f0	;fldlg2 low
	DW		0x2b3b	;fldln2 low
	DW		0x7cee	;fnclex low
	DW		0x1f0b	;fndisi low
	DW		0x8b67	;fninit low
	DW		0x2385	;fnsave low
	DW		0x0031	;fnstcw low
	DW		0x9a52	;fnstsw low
	DW		0xfa93	;format low
	DW		0xc6c7	;fpatan low
	DW		0x430f	;fprem1 low
	DW		0xf624	;frstor low
	DW		0x8ca0	;fsaved low
	DW		0xac52	;fsavew low
	DW		0xe20c	;fscale low
	DW		0xab02	;fsetpm low
	DW		0xeedc	;fstenv low
	DW		0x2d04	;fsubrp low
	DW		0x1ca3	;fucomi low
	DW		0x8900	;fucomp low
	DW		0x9721	;fxsave low
Keyword6g:
	DW		0x5ac2	;global low
Keyword6h:
	DW		0x605c	;haddpd low
	DW		0x40ae	;haddps low
	DW		0xa842	;hsubpd low
	DW		0x4ca9	;hsubps low
Keyword6i:
	DW		0xccf0	;ifndef low
	DW		0x86d6	;import low
	DW		0x1e57	;invlpg low
	DW		0xbd49	;invoke low
Keyword6j:
Keyword6k:
Keyword6l:
	DW		0x3efc	;leaved low
	DW		0x1b00	;lfence low
	DW		0x837d	;loopde low
	DW		0xefa4	;loopdz low
	DW		0x6bf7	;loopne low
	DW		0xc337	;loopnz low
Keyword6m:
	DW		0xc46c	;mfence low
	DW		0x5cb5	;movapd low
	DW		0xf475	;movaps low
	DW		0xada3	;movdqa low
	DW		0x79de	;movdqu low
	DW		0xa19d	;movhpd low
	DW		0x4576	;movhps low
	DW		0x9e53	;movlpd low
	DW		0xbea1	;movlps low
	DW		0x59eb	;movnti low
	DW		0xc1bd	;movntq low
	DW		0x8ca4	;movsxd low
	DW		0xf09f	;movupd low
	DW		0x585f	;movups low
Keyword6n:
Keyword6o:
	DW		0x43fc	;offset low
	DW		0xb021	;option low
Keyword6p:
	DW		0xb1f2	;paddsb low
	DW		0xf02c	;paddsw low
	DW		0x7cb5	;pascal low
	DW		0xa180	;pextrb low
	DW		0xba82	;pextrd low
	DW		0x3f45	;pextrq low
	DW		0x9a70	;pextrw low
	DW		0xf641	;pfnacc low
	DW		0x8533	;pfsubr low
	DW		0xc2e6	;phaddd low
	DW		0xe214	;phaddw low
	DW		0x773c	;phsubd low
	DW		0x93d7	;phsubw low
	DW		0x2ba1	;pinsrb low
	DW		0x4a8d	;pinsrd low
	DW		0x0b53	;pinsrq low
	DW		0xae66	;pinsrw low
	DW		0x88d4	;pmaxsb low
	DW		0xe9f8	;pmaxsd low
	DW		0xc90a	;pmaxsw low
	DW		0x6264	;pmaxub low
	DW		0x8b7a	;pmaxud low
	DW		0xab88	;pmaxuw low
	DW		0xc962	;pminsb low
	DW		0x6c57	;pminsd low
	DW		0x10ea	;pminsw low
	DW		0x5387	;pminub low
	DW		0xaafd	;pminud low
	DW		0x8a0f	;pminuw low
	DW		0xfb57	;pmuldq low
	DW		0x7042	;pmulhw low
	DW		0xf498	;pmulld low
	DW		0xd46a	;pmullw low
	DW		0xe19d	;pmvlzb low
	DW		0x35f3	;pmvnzb low
	DW		0xd90c	;prolog low
	DW		0x8a52	;psadbw low
	DW		0xf622	;pshufb low
	DW		0x970e	;pshufd low
	DW		0xb7fc	;pshufw low
	DW		0x4e6a	;psignb low
	DW		0xa774	;psignd low
	DW		0x8786	;psignw low
	DW		0x0fb9	;pslldq low
	DW		0xe9a3	;psrldq low
	DW		0x7fa9	;psubsb low
	DW		0xb645	;psubsw low
	DW		0x3aad	;pswapd low
	DW		0xea4f	;public low
	DW		0x6492	;pushad low
	DW		0x55d3	;pushfd low
	DW		0x8c5b	;pushfq low
	DW		0x7521	;pushfw low
Keyword6q:
Keyword6r:
	DW		0x3295	;repeat low
Keyword6s:
	DW		0x71e8	;setalc low
	DW		0xf39d	;setnae low
	DW		0x3ab4	;setnbe low
	DW		0x791c	;setnge low
	DW		0x4a67	;setnle low
	DW		0x19e6	;sfence low
	DW		0x182f	;shufpd low
	DW		0x8043	;shufps low
	DW		0xeb84	;sqrtpd low
	DW		0x5320	;sqrtps low
	DW		0x8d13	;sqrtsd low
	DW		0x69f8	;sqrtss low
	DW		0xf651	;strmid low
	DW		0x3112	;struct low
	DW		0x288e	;swapgs low
	DW		0x8fda	;sysret low
Keyword6t:
Keyword6u:
Keyword6v:
	DW		0x35bd	;vaddpd low
	DW		0x154f	;vaddps low
	DW		0x64cd	;vaddsd low
	DW		0x443f	;vaddss low
	DW		0x2f3a	;vandpd low
	DW		0xcbd1	;vandps low
	DW		0x71bf	;vcmppd low
	DW		0x2b62	;vcmpps low
	DW		0x40fe	;vcmpsd low
	DW		0xa415	;vcmpss low
	DW		0xdda1	;vdivpd low
	DW		0x394a	;vdivps low
	DW		0xece0	;vdivsd low
	DW		0x5444	;vdivss low
	DW		0x34f5	;vlddqu low
	DW		0x980e	;vmaxpd low
	DW		0xb8fc	;vmaxps low
	DW		0xc97e	;vmaxsd low
	DW		0xe98c	;vmaxss low
	DW		0xa894	;vminpd low
	DW		0x1030	;vminps low
	DW		0x99d5	;vminsd low
	DW		0x7d3e	;vminss low
	DW		0x44ae	;vmovsd low
	DW		0xa045	;vmovss low
	DW		0x2231	;vmulpd low
	DW		0x8af1	;vmulps low
	DW		0x2f01	;vmulsd low
	DW		0xcbea	;vmulss low
	DW		0x8086	;vpabsb low
	DW		0xe1aa	;vpabsd low
	DW		0xc158	;vpabsw low
	DW		0x66e5	;vpaddb low
	DW		0xc3d0	;vpaddd low
	DW		0x820e	;vpaddq low
	DW		0xe322	;vpaddw low
	DW		0x146a	;vpandn low
	DW		0xd4c4	;vpavgb low
	DW		0x5103	;vpavgw low
	DW		0xa8aa	;vpcmov low
	DW		0x325c	;vpcomb low
	DW		0x9769	;vpcomd low
	DW		0xac99	;vpcomq low
	DW		0xb79b	;vpcomw low
	DW		0x3e3c	;vpermd low
	DW		0xbbfb	;vpermq low
	DW		0x33f9	;vpperm low
	DW		0xaf65	;vprotb low
	DW		0x0a50	;vprotd low
	DW		0x8f97	;vprotq low
	DW		0xeebb	;vprotw low
	DW		0x424b	;vpshab low
	DW		0x2367	;vpshad low
	DW		0xa6a0	;vpshaq low
	DW		0x0395	;vpshaw low
	DW		0xfbb1	;vpshlb low
	DW		0x5e84	;vpshld low
	DW		0xdb43	;vpshlq low
	DW		0x325d	;vpshlw low
	DW		0x0df5	;vpslld low
	DW		0xc419	;vpsllq low
	DW		0x612c	;vpsllw low
	DW		0x56d4	;vpsrad low
	DW		0x2a69	;vpsraw low
	DW		0x9f7b	;vpsrld low
	DW		0x5697	;vpsrlq low
	DW		0xf3a2	;vpsrlw low
	DW		0xd5a2	;vpsubb low
	DW		0x7097	;vpsubd low
	DW		0xb97b	;vpsubq low
	DW		0x5065	;vpsubw low
	DW		0x4ec7	;vptest low
	DW		0xa8da	;vrcpps low
	DW		0x61f3	;vrcpss low
	DW		0x0f69	;vsubpd low
	DW		0xeb82	;vsubps low
	DW		0x69fe	;vsubsd low
	DW		0x490c	;vsubss low
	DW		0x3f2f	;vxorpd low
	DW		0x1fdd	;vxorps low
Keyword6w:
	DW		0xb059	;wbinvd low
Keyword6x:
	DW		0x1250	;xgetbv low
	DW		0x55d6	;xrstor low
	DW		0xf425	;xsavec low
	DW		0xe441	;xsaves low
	DW		0xb7c5	;xsetbv low


Keyword6High:
	DW		0x324b	;aesdec high
	DW		0x08ac	;aesenc high
	DW		0x2a9b	;aesimc high
	DW		0xfe9c	;andnpd high
	DW		0x9af7	;andnps high
	DW		0x454e	;cmovae high
	DW		0x5c55	;cmovbe high
	DW		0x7778	;cmovge high
	DW		0x2cd8	;cmovle high
	DW		0x1983	;cmovna high
	DW		0x6e84	;cmovnb high
	DW		0xfe3b	;cmovnc high
	DW		0x1eee	;cmovne high
	DW		0xf78d	;cmovng high
	DW		0x893c	;cmovnl high
	DW		0xf956	;cmovno high
	DW		0x9d3d	;cmovnp high
	DW		0xe38c	;cmovns high
	DW		0x7de8	;cmovnz high
	DW		0x24a1	;cmovpe high
	DW		0xc474	;cmovpo high
	DW		0x886b	;comisd high
	DW		0xec00	;comiss high
	DW		0xb970	;dqword high
	DW		0x219c	;elseif high
	DW		0x7b85	;enterd high
	DW		0xf98a	;export high
	DW		0x82f4	;extern high
	DW		0xb9ef	;fcmovb high
	DW		0xc985	;fcmove high
	DW		0xd432	;fcmovu high
	DW		0x7e5f	;fcomip high
	DW		0xd769	;fcompp high
	DW		0x831c	;fdivrp high
	DW		0x942a	;ffreep high
	DW		0x44fc	;ficomp high
	DW		0xeec2	;fidivr high
	DW		0xf654	;fisttp high
	DW		0xdae1	;fisubr high
	DW		0xfc77	;fldenv high
	DW		0x7dd5	;fldl2e high
	DW		0xd604	;fldl2t high
	DW		0x7d20	;fldlg2 high
	DW		0x9ed4	;fldln2 high
	DW		0x3f49	;fnclex high
	DW		0x7f19	;fndisi high
	DW		0x6410	;fninit high
	DW		0x54d3	;fnsave high
	DW		0xeab7	;fnstcw high
	DW		0xaeae	;fnstsw high
	DW		0x6908	;format high
	DW		0xe528	;fpatan high
	DW		0x9fbd	;fprem1 high
	DW		0x878a	;frstor high
	DW		0x5d7c	;fsaved high
	DW		0x37cc	;fsavew high
	DW		0x96e8	;fscale high
	DW		0xe197	;fsetpm high
	DW		0x5022	;fstenv high
	DW		0xf815	;fsubrp high
	DW		0x55a9	;fucomi high
	DW		0xcbcd	;fucomp high
	DW		0xc715	;fxsave high
	DW		0x2767	;global high
	DW		0x6285	;haddpd high
	DW		0x0835	;haddps high
	DW		0xdd79	;hsubpd high
	DW		0xb0a4	;hsubps high
	DW		0x7e96	;ifndef high
	DW		0x82ff	;import high
	DW		0x7be4	;invlpg high
	DW		0x6c29	;invoke high
	DW		0x4d57	;leaved high
	DW		0x0ef2	;lfence high
	DW		0xac53	;loopde high
	DW		0xcf55	;loopdz high
	DW		0x56bc	;loopne high
	DW		0x32d7	;loopnz high
	DW		0x4ff2	;mfence high
	DW		0x1328	;movapd high
	DW		0x7743	;movaps high
	DW		0xc9fd	;movdqa high
	DW		0xd327	;movdqu high
	DW		0x498b	;movhpd high
	DW		0x2456	;movhps high
	DW		0xf8c5	;movlpd high
	DW		0x9275	;movlps high
	DW		0x59ac	;movnti high
	DW		0x4ac0	;movntq high
	DW		0x23eb	;movsxd high
	DW		0x5e5d	;movupd high
	DW		0x3a36	;movups high
	DW		0xc23a	;offset high
	DW		0x3606	;option high
	DW		0xa5fb	;paddsb high
	DW		0x2145	;paddsw high
	DW		0xe6ef	;pascal high
	DW		0xed52	;pextrb high
	DW		0xb03a	;pextrd high
	DW		0x33e9	;pextrq high
	DW		0xda8a	;pextrw high
	DW		0x93a1	;pfnacc high
	DW		0x25f9	;pfsubr high
	DW		0xa327	;phaddd high
	DW		0xc997	;phaddw high
	DW		0xa7dc	;phsubd high
	DW		0xca01	;phsubw high
	DW		0x17ce	;pinsrb high
	DW		0xf9c0	;pinsrd high
	DW		0x7d7e	;pinsrq high
	DW		0x941d	;pinsrw high
	DW		0xf95d	;pmaxsb high
	DW		0x1753	;pmaxsd high
	DW		0x7de3	;pmaxsw high
	DW		0xc5b0	;pmaxub high
	DW		0x2565	;pmaxud high
	DW		0x4fd5	;pmaxuw high
	DW		0xb103	;pminsb high
	DW		0x5860	;pminsd high
	DW		0x26d1	;pminsw high
	DW		0x1d56	;pminub high
	DW		0xe034	;pminud high
	DW		0x8a84	;pminuw high
	DW		0xdbb8	;pmuldq high
	DW		0x7060	;pmulhw high
	DW		0x90b2	;pmulld high
	DW		0xfa02	;pmullw high
	DW		0xefc3	;pmvlzb high
	DW		0xec47	;pmvnzb high
	DW		0xf373	;prolog high
	DW		0x1c08	;psadbw high
	DW		0x078d	;pshufb high
	DW		0xe983	;pshufd high
	DW		0x8333	;pshufw high
	DW		0xfeae	;psignb high
	DW		0x1e7b	;psignd high
	DW		0x74cb	;psignw high
	DW		0xc53c	;pslldq high
	DW		0x4587	;psrldq high
	DW		0xef42	;psubsb high
	DW		0x6527	;psubsw high
	DW		0x7834	;pswapd high
	DW		0x7ab7	;public high
	DW		0x3382	;pushad high
	DW		0x2a99	;pushfd high
	DW		0xbd4b	;pushfq high
	DW		0x4029	;pushfw high
	DW		0xee35	;repeat high
	DW		0x8eba	;setalc high
	DW		0xef90	;setnae high
	DW		0xf99f	;setnbe high
	DW		0x5e72	;setnge high
	DW		0x816b	;setnle high
	DW		0xc91e	;sfence high
	DW		0x94c5	;shufpd high
	DW		0xd677	;shufps high
	DW		0x5f73	;sqrtpd high
	DW		0x26af	;sqrtps high
	DW		0x2bec	;sqrtsd high
	DW		0x4631	;sqrtss high
	DW		0xea9c	;strmid high
	DW		0xa263	;struct high
	DW		0x0ab6	;swapgs high
	DW		0xc9f8	;sysret high
	DW		0x20e0	;vaddpd high
	DW		0x4a50	;vaddps high
	DW		0xb4f4	;vaddsd high
	DW		0xde44	;vaddss high
	DW		0xee42	;vandpd high
	DW		0x839f	;vandps high
	DW		0xd91f	;vcmppd high
	DW		0x00c9	;vcmpps high
	DW		0xc004	;vcmpsd high
	DW		0xadd9	;vcmpss high
	DW		0x3019	;vdivpd high
	DW		0x5dc4	;vdivps high
	DW		0x2902	;vdivsd high
	DW		0x50de	;vdivss high
	DW		0x3787	;vlddqu high
	DW		0x6204	;vmaxpd high
	DW		0x08b4	;vmaxps high
	DW		0xf610	;vmaxsd high
	DW		0x9ca0	;vmaxss high
	DW		0x644e	;vminpd high
	DW		0x1d92	;vminps high
	DW		0x7d55	;vminsd high
	DW		0x1088	;vminss high
	DW		0xb7d0	;vmovsd high
	DW		0xda0d	;vmovss high
	DW		0x4cb7	;vmulpd high
	DW		0x28dc	;vmulps high
	DW		0x5dd5	;vmulsd high
	DW		0x3008	;vmulss high
	DW		0xf942	;vpabsb high
	DW		0x174c	;vpabsd high
	DW		0x7dfc	;vpabsw high
	DW		0x6a04	;vpaddb high
	DW		0x8367	;vpaddd high
	DW		0x07d9	;vpaddq high
	DW		0xe9d7	;vpaddw high
	DW		0x150e	;vpandn high
	DW		0xbb23	;vpavgb high
	DW		0x38f0	;vpavgw high
	DW		0x8664	;vpcmov high
	DW		0x336f	;vpcomb high
	DW		0xda0c	;vpcomd high
	DW		0xedd4	;vpcomq high
	DW		0xb0bc	;vpcomw high
	DW		0x53cd	;vpermd high
	DW		0xd01e	;vpermq high
	DW		0xdde2	;vpperm high
	DW		0xf5cb	;vprotb high
	DW		0x1ca8	;vprotd high
	DW		0x9f7b	;vprotq high
	DW		0x7175	;vprotw high
	DW		0x7138	;vpshab high
	DW		0x9f36	;vpshad high
	DW		0x1ce5	;vpshaq high
	DW		0xf586	;vpshaw high
	DW		0x1fc3	;vpshlb high
	DW		0xf6a0	;vpshld high
	DW		0x7573	;vpshlq high
	DW		0x95a6	;vpshlw high
	DW		0x0e5f	;vpslld high
	DW		0x843a	;vpsllq high
	DW		0x6d59	;vpsllw high
	DW		0xcbd5	;vpsrad high
	DW		0xb564	;vpsraw high
	DW		0x3596	;vpsrld high
	DW		0xbff3	;vpsrlq high
	DW		0x5690	;vpsrlw high
	DW		0x3d86	;vpsubb high
	DW		0xd4e5	;vpsubd high
	DW		0x5e80	;vpsubq high
	DW		0xbe55	;vpsubw high
	DW		0x7a2e	;vptest high
	DW		0x99f9	;vrcpps high
	DW		0x8ff6	;vrcpss high
	DW		0x6fc6	;vsubpd high
	DW		0x021b	;vsubps high
	DW		0x1b59	;vsubsd high
	DW		0x71e9	;vsubss high
	DW		0x4b38	;vxorpd high
	DW		0x2188	;vxorps high
	DW		0x3774	;wbinvd high
	DW		0x6516	;xgetbv high
	DW		0x3f67	;xrstor high
	DW		0xcf85	;xsavec high
	DW		0xd232	;xsaves high
	DW		0x5720	;xsetbv high


Keyword6Desc:
	DW		(aesdecInstr)	
	DW		(aesencInstr)	
	DW		(aesimcInstr)	
	DW		(andnpdInstr)	
	DW		(andnpsInstr)	
	DW		(cmovaeInstr)	
	DW		(cmovbeInstr)	
	DW		(cmovgeInstr)	
	DW		(cmovleInstr)	
	DW		(cmovbeInstr)	
	DW		(cmovaeInstr)	
	DW		(cmovaeInstr)	
	DW		(cmovnzInstr)	
	DW		(cmovleInstr)	
	DW		(cmovgeInstr)	
	DW		(cmovnoInstr)	
	DW		(cmovpoInstr)	
	DW		(cmovnsInstr)	
	DW		(cmovnzInstr)	
	DW		(cmovpInstr)	
	DW		(cmovpoInstr)	
	DW		(comisdInstr)	
	DW		(comissInstr)	
	DB		DataType, 7	
	DW		(ElseIfDirective)	
	DW		(enterdInstr)	
	DW		(ExportDirective)	
	DW		(ExternDirective)	
	DW		(fcmovbInstr)	
	DW		(fcmoveInstr)	
	DW		(fcmovuInstr)	
	DW		(fcomipInstr)	
	DW		(fcomppInstr)	
	DW		(fdivrpInstr)	
	DW		(ffreepInstr)	
	DW		(ficompInstr)	
	DW		(fidivrInstr)	
	DW		(fisttpInstr)	
	DW		(fisubrInstr)	
	DW		(fldenvInstr)	
	DW		(fldl2eInstr)	
	DW		(fldl2tInstr)	
	DW		(fldlg2Instr)	
	DW		(fldln2Instr)	
	DW		(fnclexInstr)	
	DW		(fndisiInstr)	
	DW		(fninitInstr)	
	DW		(fnsaveInstr)	
	DW		(fnstcwInstr)	
	DW		(fnstswInstr)	
	DW		(FormatDirective)	
	DW		(fpatanInstr)	
	DW		(fprem1Instr)	
	DW		(frstorInstr)	
	DW		(fsavedInstr)	
	DW		(fsavewInstr)	
	DW		(fscaleInstr)	
	DW		(fsetpmInstr)	
	DW		(fstenvInstr)	
	DW		(fsubrpInstr)	
	DW		(fucomiInstr)	
	DW		(fucompInstr)	
	DW		(fxsaveInstr)	
	DW		(GlobalDirective)	
	DW		(haddpdInstr)	
	DW		(haddpsInstr)	
	DW		(hsubpdInstr)	
	DW		(hsubpsInstr)	
	DW		(IfNDefDirective)	
	DW		(ImportDirective)	
	DW		(invlpgInstr)	
	DW		(InvokeDirective)	
	DW		(leavedInstr)	
	DW		(lfenceInstr)	
	DW		(loopdzInstr)	
	DW		(loopdzInstr)	
	DW		(loopnzInstr)	
	DW		(loopnzInstr)	
	DW		(mfenceInstr)	
	DW		(movapdInstr)	
	DW		(movapsInstr)	
	DW		(movdqaInstr)	
	DW		(movdquInstr)	
	DW		(movhpdInstr)	
	DW		(movhpsInstr)	
	DW		(movlpdInstr)	
	DW		(movlpsInstr)	
	DW		(movntiInstr)	
	DW		(movntqInstr)	
	DW		(movsxdInstr)	
	DW		(movupdInstr)	
	DW		(movupsInstr)	
	DB		operator, AddOp	
	DW		(OptionDirective)	
	DW		(paddsbInstr)	
	DW		(paddswInstr)	
	DB		Lang, 1	
	DW		(pextrbInstr)	
	DW		(pextrdInstr)	
	DW		(pextrqInstr)	
	DW		(pextrwInstr)	
	DW		(pfnaccInstr)	
	DW		(pfsubrInstr)	
	DW		(phadddInstr)	
	DW		(phaddwInstr)	
	DW		(phsubdInstr)	
	DW		(phsubwInstr)	
	DW		(pinsrbInstr)	
	DW		(pinsrdInstr)	
	DW		(pinsrqInstr)	
	DW		(pinsrwInstr)	
	DW		(pmaxsbInstr)	
	DW		(pmaxsdInstr)	
	DW		(pmaxswInstr)	
	DW		(pmaxubInstr)	
	DW		(pmaxudInstr)	
	DW		(pmaxuwInstr)	
	DW		(pminsbInstr)	
	DW		(pminsdInstr)	
	DW		(pminswInstr)	
	DW		(pminubInstr)	
	DW		(pminudInstr)	
	DW		(pminuwInstr)	
	DW		(pmuldqInstr)	
	DW		(pmulhwInstr)	
	DW		(pmulldInstr)	
	DW		(pmullwInstr)	
	DW		(pmvlzbInstr)	
	DW		(pmvnzbInstr)	
	DB		Lang, 2	
	DW		(psadbwInstr)	
	DW		(pshufbInstr)	
	DW		(pshufdInstr)	
	DW		(pshufwInstr)	
	DW		(psignbInstr)	
	DW		(psigndInstr)	
	DW		(psignwInstr)	
	DW		(pslldqInstr)	
	DW		(psrldqInstr)	
	DW		(psubsbInstr)	
	DW		(psubswInstr)	
	DW		(pswapdInstr)	
	DW		(PublicDirective)	
	DW		(pushadInstr)	
	DW		(pushfdInstr)	
	DW		(pushfqInstr)	
	DW		(pushfwInstr)	
	DW		(RepeatDirective)	
	DW		(setalcInstr)	
	DW		(setnaeInstr)	
	DW		(setnbeInstr)	
	DW		(setngeInstr)	
	DW		(setnleInstr)	
	DW		(sfenceInstr)	
	DW		(shufpdInstr)	
	DW		(shufpsInstr)	
	DW		(sqrtpdInstr)	
	DW		(sqrtpsInstr)	
	DW		(sqrtsdInstr)	
	DW		(sqrtssInstr)	
	DB		operator, 12	
	DW		(StrucDirective)	
	DW		(SwapGSInstr)	
	DW		(sysretInstr)	
	DW		(vaddpdInstr)	
	DW		(vaddpsInstr)	
	DW		(vaddsdInstr)	
	DW		(vaddssInstr)	
	DW		(vandpdInstr)	
	DW		(vandpsInstr)	
	DW		(vcmppdInstr)	
	DW		(vcmppsInstr)	
	DW		(vcmpsdInstr)	
	DW		(vcmpssInstr)	
	DW		(vdivpdInstr)	
	DW		(vdivpsInstr)	
	DW		(vdivsdInstr)	
	DW		(vdivssInstr)	
	DW		(vlddquInstr)	
	DW		(vmaxpdInstr)	
	DW		(vmaxpsInstr)	
	DW		(vmaxsdInstr)	
	DW		(vmaxssInstr)	
	DW		(vminpdInstr)	
	DW		(vminpsInstr)	
	DW		(vminsdInstr)	
	DW		(vminssInstr)	
	DW		(vmovsdInstr)	
	DW		(vmovssInstr)	
	DW		(vmulpdInstr)	
	DW		(vmulpsInstr)	
	DW		(vmulsdInstr)	
	DW		(vmulssInstr)	
	DW		(vpabsbInstr)	
	DW		(vpabsdInstr)	
	DW		(vpabswInstr)	
	DW		(vpaddbInstr)	
	DW		(vpadddInstr)	
	DW		(vpaddqInstr)	
	DW		(vpaddwInstr)	
	DW		(vpandnInstr)	
	DW		(vpavgbInstr)	
	DW		(vpavgwInstr)	
	DW		(vpcmovInstr)	
	DW		(vpcombInstr)	
	DW		(vpcomdInstr)	
	DW		(vpcomqInstr)	
	DW		(vpcomwInstr)	
	DW		(vpermdInstr)	
	DW		(vpermqInstr)	
	DW		(vppermInstr)	
	DW		(vprotbInstr)	
	DW		(vprotdInstr)	
	DW		(vprotqInstr)	
	DW		(vprotwInstr)	
	DW		(vpshabInstr)	
	DW		(vpshadInstr)	
	DW		(vpshaqInstr)	
	DW		(vpshawInstr)	
	DW		(vpshlbInstr)	
	DW		(vpshldInstr)	
	DW		(vpshlqInstr)	
	DW		(vpshlwInstr)	
	DW		(vpslldInstr)	
	DW		(vpsllqInstr)	
	DW		(vpsllwInstr)	
	DW		(vpsradInstr)	
	DW		(vpsrawInstr)	
	DW		(vpsrldInstr)	
	DW		(vpsrlqInstr)	
	DW		(vpsrlwInstr)	
	DW		(vpsubbInstr)	
	DW		(vpsubdInstr)	
	DW		(vpsubqInstr)	
	DW		(vpsubwInstr)	
	DW		(vptestInstr)	
	DW		(vrcppsInstr)	
	DW		(vrcpssInstr)	
	DW		(vsubpdInstr)	
	DW		(vsubpsInstr)	
	DW		(vsubsdInstr)	
	DW		(vsubssInstr)	
	DW		(vxorpdInstr)	
	DW		(vxorpsInstr)	
	DW		(wbinvdInstr)	
	DW		(xgetbvInstr)	
	DW		(xrstorInstr)	
	DW		(xsavecInstr)	
	DW		(xsavesInstr)	
	DW		(xsetbvInstr)	
EVEN 2
Keyword7:
	DW	000,000,002,021,021,021,045,045,045,047,047,047,051,063,063,063,096,096,102,110,111,113,197,197,198,198,198
	DW	Keyword7High, Keyword7Desc


Keyword7a:
Keyword7b:
	DW		0x076e	;blendpd low
	DW		0xe385	;blendps low
Keyword7c:
	DW		0xe74e	;clflush low
	DW		0x7a35	;cmovnae low
	DW		0x075f	;cmovnbe low
	DW		0x9085	;cmovnge low
	DW		0x4bfd	;cmovnle low
	DW		0xb8ca	;cmpeqpd low
	DW		0x100a	;cmpeqps low
	DW		0x898b	;cmpeqsd low
	DW		0x6d60	;cmpeqss low
	DW		0x3467	;cmplepd low
	DW		0x1495	;cmpleps low
	DW		0x2b06	;cmplesd low
	DW		0xcfed	;cmpless low
	DW		0x294e	;cmpltpd low
	DW		0xcda5	;cmpltps low
	DW		0x180f	;cmpltsd low
	DW		0xb0cf	;cmpltss low
	DW		0x3ee2	;cmpxchg low
	DW		0x8fae	;comment low
Keyword7d:
Keyword7e:
Keyword7f:
	DW		0xbe5f	;fcmovbe low
	DW		0xfca6	;fcmovnb low
	DW		0xcc30	;fcmovne low
	DW		0xdc54	;fcmovnu low
	DW		0xc150	;fdecstp low
	DW		0xf9ac	;fincstp low
	DW		0x5783	;fldenvd low
	DW		0x7771	;fldenvw low
	DW		0x4572	;fnldenv low
	DW		0xe868	;fnrstor low
	DW		0x5077	;fnsaved low
	DW		0x7085	;fnsavew low
	DW		0x8955	;fnstenv low
	DW		0x199e	;frndint low
	DW		0xfbf0	;frstord low
	DW		0x1f1b	;frstorw low
	DW		0x5f60	;fsincos low
	DW		0x29c6	;fstenvd low
	DW		0xcd2d	;fstenvw low
	DW		0xbfd1	;fucomip low
	DW		0x8c23	;fucompp low
	DW		0x275b	;fxrstor low
	DW		0xd59c	;fxtract low
	DW		0xf7da	;fyl2xp1 low
Keyword7g:
Keyword7h:
Keyword7i:
	DW		0x84e0	;include low
	DW		0x7a19	;insertq low
Keyword7j:
Keyword7k:
Keyword7l:
	DW		0x3cb4	;ldmxcsr low
	DW		0x08e9	;loadall low
	DW		0x400a	;loopdne low
	DW		0xe8ca	;loopdnz low
Keyword7m:
	DW		0x9b5e	;monitor low
	DW		0x4e77	;movddup low
	DW		0x12d6	;movdq2q low
	DW		0x9b8b	;movhlps low
	DW		0xf05d	;movlhps low
	DW		0x3f5e	;movntdq low
	DW		0x0ce0	;movntpd low
	DW		0xe80b	;movntps low
	DW		0x3da1	;movntsd low
	DW		0x1d53	;movntss low
	DW		0x53aa	;movq2dq low
	DW		0xc490	;mpsadbw low
Keyword7n:
Keyword7o:
Keyword7p:
	DW		0x66ed	;paddsiw low
	DW		0x07c1	;paddusb low
	DW		0x8206	;paddusw low
	DW		0xc067	;palignr low
	DW		0xe954	;pavgusb low
	DW		0xb6ae	;pblendw low
	DW		0x504b	;pcmpeqb low
	DW		0xb955	;pcmpeqd low
	DW		0x70b9	;pcmpeqq low
	DW		0xd58c	;pcmpeqw low
	DW		0xd7e6	;pcmpgtb low
	DW		0x0e54	;pcmpgtd low
	DW		0xf714	;pcmpgtq low
	DW		0x5221	;pcmpgtw low
	DW		0xd731	;pdistib low
	DW		0xcb50	;pfcmpeq low
	DW		0x1d9e	;pfcmpge low
	DW		0x9859	;pfcmpgt low
	DW		0x05ca	;pfpnacc low
	DW		0xa6ad	;pfrsqrt low
	DW		0x5292	;phaddsw low
	DW		0x36c5	;phsubsw low
	DW		0x2063	;pmaddwd low
	DW		0x0202	;pmulhrw low
	DW		0x976b	;pmulhuw low
	DW		0x311a	;pmuludq low
	DW		0x01e9	;pmvgezb low
	DW		0x7032	;private low
	DW		0x3595	;pshufhw low
	DW		0x55a4	;pshuflw low
	DW		0x3673	;psubsiw low
	DW		0x6a48	;psubusb low
	DW		0xd298	;psubusw low
Keyword7q:
Keyword7r:
	DW		0x5675	;roundpd low
	DW		0xb29e	;roundps low
	DW		0x2b1f	;roundsd low
	DW		0x83df	;roundss low
	DW		0xd77a	;rsqrtps low
	DW		0x860a	;rsqrtss low
Keyword7s:
	DW		0x3970	;section low
	DW		0x8a26	;segment low
	DW		0x26c2	;stdcall low
	DW		0x1149	;stmxcsr low
	DW		0x47c8	;strleft low
	DW		0x5014	;strscan low
	DW		0x4c40	;syscall low
	DW		0xd312	;sysexit low
Keyword7t:
	DW		0xfcfb	;typedef low
Keyword7u:
	DW		0x912e	;ucomisd low
	DW		0xb1dc	;ucomiss low
Keyword7v:
	DW		0x7df5	;vaesdec low
	DW		0x8fee	;vaesenc low
	DW		0x00ed	;vaesimc low
	DW		0x35e7	;vandnpd low
	DW		0x9d27	;vandnps low
	DW		0x7288	;vcomisd low
	DW		0x9663	;vcomiss low
	DW		0x849a	;vfrczpd low
	DW		0x6071	;vfrczps low
	DW		0x9bfb	;vfrczsd low
	DW		0xbb09	;vfrczss low
	DW		0x8443	;vhaddpd low
	DW		0x60a8	;vhaddps low
	DW		0xe257	;vhsubpd low
	DW		0x06bc	;vhsubps low
	DW		0x6b37	;vmovapd low
	DW		0x4bc5	;vmovaps low
	DW		0x7222	;vmovdqa low
	DW		0xa65f	;vmovdqu low
	DW		0xbc40	;vmovhpd low
	DW		0x58ab	;vmovhps low
	DW		0xb9b5	;vmovlpd low
	DW		0x0111	;vmovlps low
	DW		0x6335	;vmovupd low
	DW		0x87de	;vmovups low
	DW		0x02cd	;vpaddsb low
	DW		0x870a	;vpaddsw low
	DW		0x611f	;vpcomub low
	DW		0xc42a	;vpcomud low
	DW		0x3d6a	;vpcomuq low
	DW		0xe4d8	;vpcomuw low
	DW		0x9217	;vpermpd low
	DW		0x76fc	;vpermps low
	DW		0xf712	;vpextrb low
	DW		0x963e	;vpextrd low
	DW		0x13f9	;vpextrq low
	DW		0xb6cc	;vpextrw low
	DW		0x12c3	;vphaddd low
	DW		0x3231	;vphaddw low
	DW		0x78fd	;vphsubd low
	DW		0x1424	;vphsubw low
	DW		0x3084	;vpinsrb low
	DW		0xc9fe	;vpinsrd low
	DW		0x4c39	;vpinsrq low
	DW		0xe90c	;vpinsrw low
	DW		0x3c3e	;vpmaxsb low
	DW		0xc544	;vpmaxsd low
	DW		0xe5b6	;vpmaxsw low
	DW		0xa6db	;vpmaxub low
	DW		0x03ee	;vpmaxud low
	DW		0x7f53	;vpmaxuw low
	DW		0x6162	;vpminsb low
	DW		0x004e	;vpminsd low
	DW		0xe4a5	;vpminsw low
	DW		0x03e0	;vpminub low
	DW		0xeafe	;vpminud low
	DW		0x8627	;vpminuw low
	DW		0x73c3	;vpmuldq low
	DW		0xf8d6	;vpmulhw low
	DW		0xb815	;vpmulld low
	DW		0x5cfe	;vpmullw low
	DW		0xa6ee	;vpsadbw low
	DW		0xf996	;vpshufb low
	DW		0x5ca3	;vpshufd low
	DW		0x8ad5	;vpsignb low
	DW		0x2fe0	;vpsignd low
	DW		0x535d	;vpsignw low
	DW		0x28a2	;vpslldq low
	DW		0xf396	;vpsllvd low
	DW		0x3a7a	;vpsllvq low
	DW		0x56c5	;vpsravd low
	DW		0x4f17	;vpsrldq low
	DW		0x9423	;vpsrlvd low
	DW		0x11e4	;vpsrlvq low
	DW		0x3561	;vpsubsb low
	DW		0x74bf	;vpsubsw low
	DW		0xa455	;vshufpd low
	DW		0x40be	;vshufps low
	DW		0x612d	;vsqrtpd low
	DW		0x85c6	;vsqrtps low
	DW		0xf444	;vsqrtsd low
	DW		0x10af	;vsqrtss low
	DW		0xc436	;vtestpd low
	DW		0xe4c4	;vtestps low
Keyword7w:
Keyword7x:
	DW		0x6188	;xrstors low


Keyword7High:
	DW		0x61f0	;blendpd high
	DW		0x0c2d	;blendps high
	DW		0x5211	;clflush high
	DW		0x5ec7	;cmovnae high
	DW		0x4e6a	;cmovnbe high
	DW		0x622a	;cmovnge high
	DW		0x3ee7	;cmovnle high
	DW		0x776e	;cmpeqpd high
	DW		0x1305	;cmpeqps high
	DW		0x6e75	;cmpeqsd high
	DW		0x03a8	;cmpeqss high
	DW		0xbb40	;cmplepd high
	DW		0xd1f0	;cmpleps high
	DW		0xe0e0	;cmplesd high
	DW		0x8d3d	;cmpless high
	DW		0xa520	;cmpltpd high
	DW		0xc8fd	;cmpltps high
	DW		0xbc3b	;cmpltsd high
	DW		0xd850	;cmpltss high
	DW		0xa311	;cmpxchg high
	DW		0x08c5	;comment high
	DW		0x6bd2	;fcmovbe high
	DW		0x4a6f	;fcmovnb high
	DW		0x3d68	;fcmovne high
	DW		0x20df	;fcmovnu high
	DW		0xbdfa	;fdecstp high
	DW		0x09f6	;fincstp high
	DW		0x982e	;fldenvd high
	DW		0xf29e	;fldenvw high
	DW		0x33eb	;fnldenv high
	DW		0xfddb	;fnrstor high
	DW		0x4e50	;fnsaved high
	DW		0x24e0	;fnsavew high
	DW		0x518b	;fnstenv high
	DW		0x963c	;frndint high
	DW		0x015c	;frstord high
	DW		0x6c81	;frstorw high
	DW		0xe41d	;fsincos high
	DW		0xb2ed	;fstenvd high
	DW		0xdf30	;fstenvw high
	DW		0x81eb	;fucomip high
	DW		0x27c9	;fucompp high
	DW		0x93ae	;fxrstor high
	DW		0x49a3	;fxtract high
	DW		0x27cf	;fyl2xp1 high
	DW		0x3255	;include high
	DW		0x02ac	;insertq high
	DW		0x1089	;ldmxcsr high
	DW		0x57e3	;loadall high
	DW		0xb505	;loopdne high
	DW		0xd16e	;loopdnz high
	DW		0x99c3	;monitor high
	DW		0x6de5	;movddup high
	DW		0xbcb3	;movdq2q high
	DW		0x3958	;movhlps high
	DW		0x700a	;movlhps high
	DW		0x8470	;movntdq high
	DW		0xc703	;movntpd high
	DW		0xaade	;movntps high
	DW		0xde18	;movntsd high
	DW		0xb4a8	;movntss high
	DW		0xe9c4	;movq2dq high
	DW		0x0b20	;mpsadbw high
	DW		0xd5bc	;paddsiw high
	DW		0xd0f9	;paddusb high
	DW		0x532a	;paddusw high
	DW		0xcaf1	;palignr high
	DW		0x81c9	;pavgusb high
	DW		0xd972	;pblendw high
	DW		0xa3de	;pcmpeqb high
	DW		0x430b	;pcmpeqd high
	DW		0xc96e	;pcmpeqq high
	DW		0x200d	;pcmpeqw high
	DW		0x8b77	;pcmpgtb high
	DW		0x4d7b	;pcmpgtd high
	DW		0xe1c7	;pcmpgtq high
	DW		0x08a4	;pcmpgtw high
	DW		0x95bb	;pdistib high
	DW		0xa2c0	;pfcmpeq high
	DW		0x0723	;pfcmpge high
	DW		0x84f0	;pfcmpgt high
	DW		0x1011	;pfpnacc high
	DW		0xd656	;pfrsqrt high
	DW		0xc719	;phaddsw high
	DW		0x2b79	;phsubsw high
	DW		0x2e5d	;pmaddwd high
	DW		0x6e85	;pmulhrw high
	DW		0xfdfc	;pmulhuw high
	DW		0x5751	;pmuludq high
	DW		0x1018	;pmvgezb high
	DW		0x5fb9	;private high
	DW		0xf282	;pshufhw high
	DW		0x7f8d	;pshuflw high
	DW		0xc741	;psubsiw high
	DW		0x9bb7	;psubusb high
	DW		0x41d7	;psubusw high
	DW		0xd533	;roundpd high
	DW		0xb8ee	;roundps high
	DW		0xc59e	;roundsd high
	DW		0xa1f5	;roundss high
	DW		0x4bdd	;rsqrtps high
	DW		0xdfc9	;rsqrtss high
	DW		0x34b6	;section high
	DW		0x1835	;segment high
	DW		0x3e8e	;stdcall high
	DW		0x8075	;stmxcsr high
	DW		0xd12d	;strleft high
	DW		0xfa35	;strscan high
	DW		0x874e	;syscall high
	DW		0x75a8	;sysexit high
	DW		0x42ba	;typedef high
	DW		0x7e31	;ucomisd high
	DW		0x1481	;ucomiss high
	DW		0x9467	;vaesdec high
	DW		0x36ee	;vaesenc high
	DW		0x0708	;vaesimc high
	DW		0xf11a	;vandnpd high
	DW		0x9571	;vandnps high
	DW		0x385e	;vcomisd high
	DW		0x5583	;vcomiss high
	DW		0x25e7	;vfrczpd high
	DW		0x483a	;vfrczps high
	DW		0x7e47	;vfrczsd high
	DW		0x14f7	;vfrczss high
	DW		0x6eda	;vhaddpd high
	DW		0x0307	;vhaddps high
	DW		0x6628	;vhsubpd high
	DW		0x0bf5	;vhsubps high
	DW		0x3d0d	;vmovapd high
	DW		0x57bd	;vmovaps high
	DW		0x640c	;vmovdqa high
	DW		0x7ed6	;vmovdqu high
	DW		0x1652	;vmovhpd high
	DW		0x7b8f	;vmovhps high
	DW		0xcb57	;vmovlpd high
	DW		0xb28b	;vmovlps high
	DW		0xfa1a	;vmovupd high
	DW		0x97c7	;vmovups high
	DW		0x8b50	;vpaddsb high
	DW		0x0883	;vpaddsw high
	DW		0xe58c	;vpcomub high
	DW		0x0cef	;vpcomud high
	DW		0xa053	;vpcomuq high
	DW		0x665f	;vpcomuw high
	DW		0xd244	;vpermpd high
	DW		0xbf99	;vpermps high
	DW		0x448d	;vpextrb high
	DW		0xaa83	;vpextrd high
	DW		0x2950	;vpextrq high
	DW		0xc033	;vpextrw high
	DW		0xefff	;vphaddd high
	DW		0x854f	;vphaddw high
	DW		0x885b	;vphsubd high
	DW		0xeb5d	;vphsubw high
	DW		0x5024	;vpinsrb high
	DW		0xad46	;vpinsrd high
	DW		0x2e95	;vpinsrq high
	DW		0xc7f6	;vpinsrw high
	DW		0xf088	;vpmaxsb high
	DW		0x0dea	;vpmaxsd high
	DW		0x675a	;vpmaxsw high
	DW		0x5cdd	;vpmaxub high
	DW		0xb5be	;vpmaxud high
	DW		0xcb0f	;vpmaxuw high
	DW		0x61df	;vpminsb high
	DW		0x8fd1	;vpminsd high
	DW		0xe20c	;vpminsw high
	DW		0x53e9	;vpminub high
	DW		0xb33c	;vpminud high
	DW		0xd03a	;vpminuw high
	DW		0x4b63	;vpmuldq high
	DW		0xe0bb	;vpmulhw high
	DW		0x0704	;vpmulld high
	DW		0x6ad9	;vpmullw high
	DW		0x06b1	;vpsadbw high
	DW		0x1cdd	;vpshufb high
	DW		0xf5be	;vpshufd high
	DW		0x67c3	;vpsignb high
	DW		0x8ea0	;vpsignd high
	DW		0xf011	;vpsignw high
	DW		0x9ddc	;vpslldq high
	DW		0x2440	;vpsllvd high
	DW		0xae25	;vpsllvq high
	DW		0xc596	;vpsravd high
	DW		0x97e7	;vpsrldq high
	DW		0x2e7b	;vpsrlvd high
	DW		0xada8	;vpsrlvq high
	DW		0x8db1	;vpsubsb high
	DW		0x090f	;vpsubsw high
	DW		0x2372	;vshufpd high
	DW		0x4eaf	;vshufps high
	DW		0x1f73	;vsqrtpd high
	DW		0x72ae	;vsqrtps high
	DW		0x8c0a	;vsqrtsd high
	DW		0xe1d7	;vsqrtss high
	DW		0xbbb1	;vtestpd high
	DW		0xd101	;vtestps high
	DW		0x3f8a	;xrstors high


Keyword7Desc:
	DW		(blendpdInstr)	
	DW		(blendpsInstr)	
	DW		(clflushInstr)	
	DW		(cmovbInstr)	
	DW		(cmovaInstr)	
	DW		(cmovlInstr)	
	DW		(cmovgInstr)	
	DW		(cmpeqpdInstr)	
	DW		(cmpeqpsInstr)	
	DW		(cmpeqsdInstr)	
	DW		(cmpeqssInstr)	
	DW		(cmplepdInstr)	
	DW		(cmplepsInstr)	
	DW		(cmplesdInstr)	
	DW		(cmplessInstr)	
	DW		(cmpltpdInstr)	
	DW		(cmpltpsInstr)	
	DW		(cmpltsdInstr)	
	DW		(cmpltssInstr)	
	DW		(cmpxchgInstr)	
	DW		(CommentDirective)	
	DW		(fcmovbeInstr)	
	DW		(fcmovnbInstr)	
	DW		(fcmovneInstr)	
	DW		(fcmovnuInstr)	
	DW		(fdecstpInstr)	
	DW		(fincstpInstr)	
	DW		(fldenvdInstr)	
	DW		(fldenvwInstr)	
	DW		(fnldenvInstr)	
	DW		(fnrstorInstr)	
	DW		(fnsavedInstr)	
	DW		(fnsavewInstr)	
	DW		(fnstenvInstr)	
	DW		(frndintInstr)	
	DW		(frstordInstr)	
	DW		(frstorwInstr)	
	DW		(fsincosInstr)	
	DW		(fstenvdInstr)	
	DW		(fstenvwInstr)	
	DW		(fucomipInstr)	
	DW		(fucomppInstr)	
	DW		(fxrstorInstr)	
	DW		(fxtractInstr)	
	DW		(fyl2xp1Instr)	
	DW		(IncludeDirective)	
	DW		(insertqInstr)	
	DW		(ldmxcsrInstr)	
	DW		(loadallInstr)	
	DW		(loopdnzInstr)	
	DW		(loopdnzInstr)	
	DW		(monitorInstr)	
	DW		(movddupInstr)	
	DW		(movdq2qInstr)	
	DW		(movhlpsInstr)	
	DW		(movlhpsInstr)	
	DW		(movntdqInstr)	
	DW		(movntpdInstr)	
	DW		(movntpsInstr)	
	DW		(movntsdInstr)	
	DW		(movntssInstr)	
	DW		(movq2dqInstr)	
	DW		(mpsadbwInstr)	
	DW		(paddsiwInstr)	
	DW		(paddusbInstr)	
	DW		(padduswInstr)	
	DW		(palignrInstr)	
	DW		(pavgusbInstr)	
	DW		(pblendwInstr)	
	DW		(pcmpeqbInstr)	
	DW		(pcmpeqdInstr)	
	DW		(pcmpeqqInstr)	
	DW		(pcmpeqwInstr)	
	DW		(pcmpgtbInstr)	
	DW		(pcmpgtdInstr)	
	DW		(pcmpgtqInstr)	
	DW		(pcmpgtwInstr)	
	DW		(pdistibInstr)	
	DW		(pfcmpeqInstr)	
	DW		(pfcmpgeInstr)	
	DW		(pfcmpgtInstr)	
	DW		(pfpnaccInstr)	
	DW		(pfrsqrtInstr)	
	DW		(phaddswInstr)	
	DW		(phsubswInstr)	
	DW		(pmaddwdInstr)	
	DW		(pmulhrwInstr)	
	DW		(pmulhuwInstr)	
	DW		(pmuludqInstr)	
	DW		(pmvgezbInstr)	
	DB		options, 11	
	DW		(pshufhwInstr)	
	DW		(pshuflwInstr)	
	DW		(psubsiwInstr)	
	DW		(psubusbInstr)	
	DW		(psubuswInstr)	
	DW		(roundpdInstr)	
	DW		(roundpsInstr)	
	DW		(roundsdInstr)	
	DW		(roundssInstr)	
	DW		(rsqrtpsInstr)	
	DW		(rsqrtssInstr)	
	DW		(SegmentDirective)	
	DW		(SegmentDirective)	
	DB		Lang, 3	
	DW		(stmxcsrInstr)	
	DB		operator, 13	
	DB		operator, 14	
	DW		(syscallInstr)	
	DW		(sysexitInstr)	
	DW		(typedefDirective)	
	DW		(ucomisdInstr)	
	DW		(ucomissInstr)	
	DW		(vaesdecInstr)	
	DW		(vaesencInstr)	
	DW		(vaesimcInstr)	
	DW		(vandnpdInstr)	
	DW		(vandnpsInstr)	
	DW		(vcomisdInstr)	
	DW		(vcomissInstr)	
	DW		(vfrczpdInstr)	
	DW		(vfrczpsInstr)	
	DW		(vfrczsdInstr)	
	DW		(vfrczssInstr)	
	DW		(vhaddpdInstr)	
	DW		(vhaddpsInstr)	
	DW		(vhsubpdInstr)	
	DW		(vhsubpsInstr)	
	DW		(vmovapdInstr)	
	DW		(vmovapsInstr)	
	DW		(vmovdqaInstr)	
	DW		(vmovdquInstr)	
	DW		(vmovhpdInstr)	
	DW		(vmovhpsInstr)	
	DW		(vmovlpdInstr)	
	DW		(vmovlpsInstr)	
	DW		(vmovupdInstr)	
	DW		(vmovupsInstr)	
	DW		(vpaddsbInstr)	
	DW		(vpaddswInstr)	
	DW		(vpcomubInstr)	
	DW		(vpcomudInstr)	
	DW		(vpcomuqInstr)	
	DW		(vpcomuwInstr)	
	DW		(vpermpdInstr)	
	DW		(vpermpsInstr)	
	DW		(vpextrbInstr)	
	DW		(vpextrdInstr)	
	DW		(vpextrqInstr)	
	DW		(vpextrwInstr)	
	DW		(vphadddInstr)	
	DW		(vphaddwInstr)	
	DW		(vphsubdInstr)	
	DW		(vphsubwInstr)	
	DW		(vpinsrbInstr)	
	DW		(vpinsrdInstr)	
	DW		(vpinsrqInstr)	
	DW		(vpinsrwInstr)	
	DW		(vpmaxsbInstr)	
	DW		(vpmaxsdInstr)	
	DW		(vpmaxswInstr)	
	DW		(vpmaxubInstr)	
	DW		(vpmaxudInstr)	
	DW		(vpmaxuwInstr)	
	DW		(vpminsbInstr)	
	DW		(vpminsdInstr)	
	DW		(vpminswInstr)	
	DW		(vpminubInstr)	
	DW		(vpminudInstr)	
	DW		(vpminuwInstr)	
	DW		(vpmuldqInstr)	
	DW		(vpmulhwInstr)	
	DW		(vpmulldInstr)	
	DW		(vpmullwInstr)	
	DW		(vpsadbwInstr)	
	DW		(vpshufbInstr)	
	DW		(vpshufdInstr)	
	DW		(vpsignbInstr)	
	DW		(vpsigndInstr)	
	DW		(vpsignwInstr)	
	DW		(vpslldqInstr)	
	DW		(vpsllvdInstr)	
	DW		(vpsllvqInstr)	
	DW		(vpsravdInstr)	
	DW		(vpsrldqInstr)	
	DW		(vpsrlvdInstr)	
	DW		(vpsrlvqInstr)	
	DW		(vpsubsbInstr)	
	DW		(vpsubswInstr)	
	DW		(vshufpdInstr)	
	DW		(vshufpsInstr)	
	DW		(vsqrtpdInstr)	
	DW		(vsqrtpsInstr)	
	DW		(vsqrtsdInstr)	
	DW		(vsqrtssInstr)	
	DW		(vtestpdInstr)	
	DW		(vtestpsInstr)	
	DW		(xrstorsInstr)	
EVEN 2
Keyword8:
	DW	000,002,004,036,036,036,040,040,040,041,041,041,041,047,047,047,072,072,073,079,079,083,145,145,146,146,146
	DW	Keyword8High, Keyword8Desc


Keyword8a:
	DW		0xc9e5	;addsubpd low
	DW		0xe917	;addsubps low
Keyword8b:
	DW		0xd658	;blendvpd low
	DW		0x32b3	;blendvps low
Keyword8c:
	DW		0x4a55	;cmpneqpd low
	DW		0x6aa7	;cmpneqps low
	DW		0x63c7	;cmpneqsd low
	DW		0x872c	;cmpneqss low
	DW		0x574c	;cmpnlepd low
	DW		0xb3a7	;cmpnleps low
	DW		0xc225	;cmpnlesd low
	DW		0x26ce	;cmpnless low
	DW		0x159a	;cmpnltpd low
	DW		0x3568	;cmpnltps low
	DW		0xe0c2	;cmpnltsd low
	DW		0x0429	;cmpnltss low
	DW		0x12d0	;cmpordpd low
	DW		0xf63b	;cmpordps low
	DW		0xe788	;cmpordsd low
	DW		0xc77a	;cmpordss low
	DW		0x2252	;cvtdq2pd low
	DW		0xc6b9	;cvtdq2ps low
	DW		0xfd12	;cvtpd2dq low
	DW		0x1724	;cvtpd2pi low
	DW		0x2a47	;cvtpd2ps low
	DW		0x2b76	;cvtpi2pd low
	DW		0xb31a	;cvtpi2ps low
	DW		0x151e	;cvtps2dq low
	DW		0xaca8	;cvtps2pd low
	DW		0x7520	;cvtps2pi low
	DW		0x20cc	;cvtsd2si low
	DW		0x959d	;cvtsd2ss low
	DW		0x98c0	;cvtsi2sd low
	DW		0x7c2b	;cvtsi2ss low
	DW		0xd65f	;cvtss2sd low
	DW		0xcbce	;cvtss2si low
Keyword8d:
Keyword8e:
Keyword8f:
	DW		0x6955	;fcmovnbe low
	DW		0xda09	;fnstenvd low
	DW		0xfafb	;fnstenvw low
	DW		0xd322	;function low
Keyword8g:
Keyword8h:
Keyword8i:
	DW		0xe341	;insertps low
Keyword8j:
Keyword8k:
Keyword8l:
Keyword8m:
	DW		0xbe4d	;maskmovq low
	DW		0xc09e	;movmskpd low
	DW		0x2475	;movmskps low
	DW		0x31af	;movntdqa low
	DW		0x3fca	;movshdup low
	DW		0xf480	;movsldup low
Keyword8n:
Keyword8o:
Keyword8p:
	DW		0xe408	;packssdw low
	DW		0x42df	;packsswb low
	DW		0x6fba	;packusdw low
	DW		0xe74d	;packuswb low
	DW		0x9f78	;pblendvb low
	DW		0xf4ca	;pfrcpit1 low
	DW		0xc45c	;pfrcpit2 low
	DW		0x60c9	;pfrsqit1 low
	DW		0x6e48	;pmachriw low
	DW		0x748f	;pmovmskb low
	DW		0xd3c3	;pmovsxbd low
	DW		0x6b13	;pmovsxbq low
	DW		0xf331	;pmovsxbw low
	DW		0x90ae	;pmovsxdq low
	DW		0x9251	;pmovsxwd low
	DW		0x1796	;pmovsxwq low
	DW		0x3cba	;pmovzxbd low
	DW		0xb97d	;pmovzxbq low
	DW		0x1c48	;pmovzxbw low
	DW		0xdbff	;pmovzxdq low
	DW		0xd900	;pmovzxwd low
	DW		0x98de	;pmovzxwq low
	DW		0x0ff8	;pmulhriw low
	DW		0xf523	;pmulhrsw low
	DW		0xa10d	;prefetch low
Keyword8q:
Keyword8r:
	DW		0x410c	;resource low
Keyword8s:
	DW		0xd308	;sha1msg1 low
	DW		0x2787	;sha1msg2 low
	DW		0x1240	;strlcase low
	DW		0x5a02	;strright low
	DW		0x42ac	;strucase low
	DW		0x35f9	;sysenter low
Keyword8t:
Keyword8u:
	DW		0xd6a2	;unpckhpd low
	DW		0xf650	;unpckhps low
	DW		0x6c4a	;unpcklpd low
	DW		0x88a1	;unpcklps low
Keyword8v:
	DW		0x4068	;vblendpd low
	DW		0xf8cc	;vblendps low
	DW		0x7405	;vfmaddpd low
	DW		0x90ee	;vfmaddps low
	DW		0x190b	;vfmaddsd low
	DW		0xa1af	;vfmaddss low
	DW		0x29ba	;vfmsubpd low
	DW		0x0948	;vfmsubps low
	DW		0x18fb	;vfmsubsd low
	DW		0xfc10	;vfmsubss low
	DW		0xc1b0	;vldmxcsr low
	DW		0x3488	;vmovddup low
	DW		0xb0c4	;vmovhlps low
	DW		0x1946	;vmovlhps low
	DW		0xd802	;vmovntdq low
	DW		0xebbc	;vmovntpd low
	DW		0xcb4e	;vmovntps low
	DW		0xa71d	;vmpsadbw low
	DW		0xbf9c	;vpaddusb low
	DW		0xfe42	;vpaddusw low
	DW		0x480a	;vpalignr low
	DW		0x8992	;vpblendd low
	DW		0xa960	;vpblendw low
	DW		0x78b6	;vpcmpeqb low
	DW		0xdd83	;vpcmpeqd low
	DW		0xe672	;vpcmpeqq low
	DW		0xfd71	;vpcmpeqw low
	DW		0xc0d5	;vpcmpgtb low
	DW		0xa1f9	;vpcmpgtd low
	DW		0xe027	;vpcmpgtq low
	DW		0x4512	;vpcmpgtw low
	DW		0x5e49	;vphaddbd low
	DW		0x97a5	;vphaddbq low
	DW		0x7ebb	;vphaddbw low
	DW		0x1d24	;vphadddq low
	DW		0x43ae	;vphaddsw low
	DW		0xbbf3	;vphaddwd low
	DW		0x3e34	;vphaddwq low
	DW		0xe95a	;vphsubbw low
	DW		0xa4e5	;vphsubdq low
	DW		0xa8c8	;vphsubsw low
	DW		0x2c12	;vphsubwd low
	DW		0xc09b	;vpmacsdd low
	DW		0x2792	;vpmacswd low
	DW		0xc379	;vpmacsww low
	DW		0xd02b	;vpmaddwd low
	DW		0xbf96	;vpmulhuw low
	DW		0xefc7	;vpmuludq low
	DW		0x0811	;vpshufhw low
	DW		0x120f	;vpshuflw low
	DW		0x80e1	;vpsubusb low
	DW		0xc13f	;vpsubusw low
	DW		0xb36c	;vroundpd low
	DW		0x5787	;vroundps low
	DW		0xe026	;vroundsd low
	DW		0x48e6	;vroundss low
	DW		0x9596	;vrsqrtps low
	DW		0xa4d7	;vrsqrtss low
	DW		0xf34a	;vstmxcsr low
	DW		0x6153	;vucomisd low
	DW		0x85b8	;vucomiss low
	DW		0xb54b	;vzeroall low
Keyword8w:
Keyword8x:
	DW		0x7c2b	;xsaveopt low


Keyword8High:
	DW		0x2189	;addsubpd high
	DW		0x4b39	;addsubps high
	DW		0x8417	;blendvpd high
	DW		0xe9ca	;blendvps high
	DW		0x56fe	;cmpneqpd high
	DW		0x3c4e	;cmpneqps high
	DW		0xd218	;cmpneqsd high
	DW		0xbfc5	;cmpneqss high
	DW		0xbef4	;cmpnlepd high
	DW		0xd329	;cmpnleps high
	DW		0x2d8d	;cmpnlesd high
	DW		0x4050	;cmpnless high
	DW		0x9cd5	;cmpnltpd high
	DW		0xf665	;cmpnltps high
	DW		0x82a3	;cmpnltsd high
	DW		0xef7e	;cmpnltss high
	DW		0x6f9d	;cmpordpd high
	DW		0x0240	;cmpordps high
	DW		0x71eb	;cmpordsd high
	DW		0x1b5b	;cmpordss high
	DW		0x6993	;cvtdq2pd high
	DW		0x044e	;cvtdq2ps high
	DW		0x16dd	;cvtpd2dq high
	DW		0xc27c	;cvtpd2pi high
	DW		0x3873	;cvtpd2ps high
	DW		0xd663	;cvtpi2pd high
	DW		0x94d1	;cvtpi2ps high
	DW		0x3d8f	;cvtps2dq high
	DW		0xb625	;cvtps2pd high
	DW		0x21f7	;cvtps2pi high
	DW		0x5ea6	;cvtsd2si high
	DW		0xaa72	;cvtsd2ss high
	DW		0x02cb	;cvtsi2sd high
	DW		0x6f16	;cvtsi2ss high
	DW		0x3475	;cvtss2sd high
	DW		0xa4ca	;cvtss2si high
	DW		0x9c43	;fcmovnbe high
	DW		0xc886	;fnstenvd high
	DW		0xa236	;fnstenvw high
	DW		0x9f31	;function high
	DW		0x7b2d	;insertps high
	DW		0x2c27	;maskmovq high
	DW		0xc81a	;movmskpd high
	DW		0xa5c7	;movmskps high
	DW		0x7658	;movntdqa high
	DW		0x122d	;movshdup high
	DW		0x3040	;movsldup high
	DW		0x16ac	;packssdw high
	DW		0xc6a6	;packsswb high
	DW		0x3043	;packusdw high
	DW		0xa2f2	;packuswb high
	DW		0xce21	;pblendvb high
	DW		0xcf63	;pfrcpit1 high
	DW		0xb864	;pfrcpit2 high
	DW		0xc966	;pfrsqit1 high
	DW		0xa8e2	;pmachriw high
	DW		0xa048	;pmovmskb high
	DW		0xac49	;pmovsxbd high
	DW		0x7629	;pmovsxbq high
	DW		0xc6f9	;pmovsxbw high
	DW		0x97ce	;pmovsxdq high
	DW		0xcda6	;pmovsxwd high
	DW		0x4e75	;pmovsxwq high
	DW		0xee22	;pmovzxbd high
	DW		0x6df1	;pmovzxbq high
	DW		0x8492	;pmovzxbw high
	DW		0x5fc7	;pmovzxdq high
	DW		0x05af	;pmovzxwd high
	DW		0x8111	;pmovzxwq high
	DW		0x8347	;pmulhriw high
	DW		0x336a	;pmulhrsw high
	DW		0x17ae	;prefetch high
	DW		0x909f	;resource high
	DW		0xdfe3	;sha1msg1 high
	DW		0xaf89	;sha1msg2 high
	DW		0xe187	;strlcase high
	DW		0x9830	;strright high
	DW		0x5cb9	;strucase high
	DW		0x8b03	;sysenter high
	DW		0x323c	;unpckhpd high
	DW		0x588c	;unpckhps high
	DW		0xf4f8	;unpcklpd high
	DW		0x9925	;unpcklps high
	DW		0x86fa	;vblendpd high
	DW		0xff26	;vblendps high
	DW		0x8b58	;vfmaddpd high
	DW		0xe685	;vfmaddps high
	DW		0x8642	;vfmaddsd high
	DW		0xff9e	;vfmaddss high
	DW		0x3dda	;vfmsubpd high
	DW		0x576a	;vfmsubps high
	DW		0x24c1	;vfmsubsd high
	DW		0x491c	;vfmsubss high
	DW		0x7a6f	;vldmxcsr high
	DW		0xd0fd	;vmovddup high
	DW		0x76d8	;vmovhlps high
	DW		0x3129	;vmovlhps high
	DW		0xf701	;vmovntdq high
	DW		0xb472	;vmovntpd high
	DW		0xdec2	;vmovntps high
	DW		0xad53	;vmpsadbw high
	DW		0xb4fe	;vpaddusb high
	DW		0x3040	;vpaddusw high
	DW		0x9511	;vpalignr high
	DW		0x4932	;vpblendd high
	DW		0x2382	;vpblendw high
	DW		0xde4e	;vpcmpeqb high
	DW		0x372d	;vpcmpeqd high
	DW		0x00f5	;vpcmpeqq high
	DW		0x5d9d	;vpcmpeqw high
	DW		0x47a9	;vpcmpgtb high
	DW		0xa9a7	;vpcmpgtd high
	DW		0x2d19	;vpcmpgtq high
	DW		0xc47a	;vpcmpgtw high
	DW		0x6900	;vphaddbd high
	DW		0xe365	;vphaddbq high
	DW		0x03b0	;vphaddbw high
	DW		0x5287	;vphadddq high
	DW		0x4d30	;vphaddsw high
	DW		0x828d	;vphaddwd high
	DW		0x015e	;vphaddwq high
	DW		0x800d	;vphsubbw high
	DW		0x9381	;vphsubdq high
	DW		0xe1e2	;vphsubsw high
	DW		0x0130	;vphsubwd high
	DW		0x039d	;vpmacsdd high
	DW		0x5729	;vpmacswd high
	DW		0x3af4	;vpmacsww high
	DW		0xb32d	;vpmaddwd high
	DW		0x806c	;vpmulhuw high
	DW		0x86f0	;vpmuludq high
	DW		0x00fc	;vpshufhw high
	DW		0x3e95	;vpshuflw high
	DW		0xe884	;vpsubusb high
	DW		0x6c3a	;vpsubusw high
	DW		0xc707	;vroundpd high
	DW		0xaada	;vroundps high
	DW		0x9511	;vroundsd high
	DW		0xf17a	;vroundss high
	DW		0x7387	;vrsqrtps high
	DW		0x6a9c	;vrsqrtss high
	DW		0x3d18	;vstmxcsr high
	DW		0xb090	;vucomisd high
	DW		0xdd4d	;vucomiss high
	DW		0x04f2	;vzeroall high
	DW		0xa37c	;xsaveopt high


Keyword8Desc:
	DW		(addsubpdInstr)	
	DW		(addsubpsInstr)	
	DW		(blendvpdInstr)	
	DW		(blendvpsInstr)	
	DW		(cmpneqpdInstr)	
	DW		(cmpneqpsInstr)	
	DW		(cmpneqsdInstr)	
	DW		(cmpneqssInstr)	
	DW		(cmpnlepdInstr)	
	DW		(cmpnlepsInstr)	
	DW		(cmpnlesdInstr)	
	DW		(cmpnlessInstr)	
	DW		(cmpnltpdInstr)	
	DW		(cmpnltpsInstr)	
	DW		(cmpnltsdInstr)	
	DW		(cmpnltssInstr)	
	DW		(cmpordpdInstr)	
	DW		(cmpordpsInstr)	
	DW		(cmpordsdInstr)	
	DW		(cmpordssInstr)	
	DW		(cvtdq2pdInstr)	
	DW		(cvtdq2psInstr)	
	DW		(cvtpd2dqInstr)	
	DW		(cvtpd2piInstr)	
	DW		(cvtpd2psInstr)	
	DW		(cvtpi2pdInstr)	
	DW		(cvtpi2psInstr)	
	DW		(cvtps2dqInstr)	
	DW		(cvtps2pdInstr)	
	DW		(cvtps2piInstr)	
	DW		(cvtsd2siInstr)	
	DW		(cvtsd2ssInstr)	
	DW		(cvtsi2sdInstr)	
	DW		(cvtsi2ssInstr)	
	DW		(cvtss2sdInstr)	
	DW		(cvtss2siInstr)	
	DW		(fcmovnbeInstr)	
	DW		(fnstenvdInstr)	
	DW		(fnstenvwInstr)	
	DW		(FunctionDirective)	
	DW		(insertpsInstr)	
	DW		(maskmovqInstr)	
	DW		(movmskpdInstr)	
	DW		(movmskpsInstr)	
	DW		(movntdqaInstr)	
	DW		(movshdupInstr)	
	DW		(movsldupInstr)	
	DW		(packssdwInstr)	
	DW		(packsswbInstr)	
	DW		(packusdwInstr)	
	DW		(packuswbInstr)	
	DW		(pblendvbInstr)	
	DW		(pfrcpit1Instr)	
	DW		(pfrcpit2Instr)	
	DW		(pfrsqit1Instr)	
	DW		(pmachriwInstr)	
	DW		(pmovmskbInstr)	
	DW		(pmovsxbdInstr)	
	DW		(pmovsxbqInstr)	
	DW		(pmovsxbwInstr)	
	DW		(pmovsxdqInstr)	
	DW		(pmovsxwdInstr)	
	DW		(pmovsxwqInstr)	
	DW		(pmovzxbdInstr)	
	DW		(pmovzxbqInstr)	
	DW		(pmovzxbwInstr)	
	DW		(pmovzxdqInstr)	
	DW		(pmovzxwdInstr)	
	DW		(pmovzxwqInstr)	
	DW		(pmulhriwInstr)	
	DW		(pmulhrswInstr)	
	DW		(prefetchInstr)	
	DW		(ResourceDirective)	
	DW		(sha1msg1Instr)	
	DW		(sha1msg2Instr)	
	DB		operator, 10	
	DB		operator, 15	
	DB		operator, 11	
	DW		(sysenterInstr)	
	DW		(unpckhpdInstr)	
	DW		(unpckhpsInstr)	
	DW		(unpcklpdInstr)	
	DW		(unpcklpsInstr)	
	DW		(vblendpdInstr)	
	DW		(vblendpsInstr)	
	DW		(vfmaddpdInstr)	
	DW		(vfmaddpsInstr)	
	DW		(vfmaddsdInstr)	
	DW		(vfmaddssInstr)	
	DW		(vfmsubpdInstr)	
	DW		(vfmsubpsInstr)	
	DW		(vfmsubsdInstr)	
	DW		(vfmsubssInstr)	
	DW		(vldmxcsrInstr)	
	DW		(vmovddupInstr)	
	DW		(vmovhlpsInstr)	
	DW		(vmovlhpsInstr)	
	DW		(vmovntdqInstr)	
	DW		(vmovntpdInstr)	
	DW		(vmovntpsInstr)	
	DW		(vmpsadbwInstr)	
	DW		(vpaddusbInstr)	
	DW		(vpadduswInstr)	
	DW		(vpalignrInstr)	
	DW		(vpblenddInstr)	
	DW		(vpblendwInstr)	
	DW		(vpcmpeqbInstr)	
	DW		(vpcmpeqdInstr)	
	DW		(vpcmpeqqInstr)	
	DW		(vpcmpeqwInstr)	
	DW		(vpcmpgtbInstr)	
	DW		(vpcmpgtdInstr)	
	DW		(vpcmpgtqInstr)	
	DW		(vpcmpgtwInstr)	
	DW		(vphaddbdInstr)	
	DW		(vphaddbqInstr)	
	DW		(vphaddbwInstr)	
	DW		(vphadddqInstr)	
	DW		(vphaddswInstr)	
	DW		(vphaddwdInstr)	
	DW		(vphaddwqInstr)	
	DW		(vphsubbwInstr)	
	DW		(vphsubdqInstr)	
	DW		(vphsubswInstr)	
	DW		(vphsubwdInstr)	
	DW		(vpmacsddInstr)	
	DW		(vpmacswdInstr)	
	DW		(vpmacswwInstr)	
	DW		(vpmaddwdInstr)	
	DW		(vpmulhuwInstr)	
	DW		(vpmuludqInstr)	
	DW		(vpshufhwInstr)	
	DW		(vpshuflwInstr)	
	DW		(vpsubusbInstr)	
	DW		(vpsubuswInstr)	
	DW		(vroundpdInstr)	
	DW		(vroundpsInstr)	
	DW		(vroundsdInstr)	
	DW		(vroundssInstr)	
	DW		(vrsqrtpsInstr)	
	DW		(vrsqrtssInstr)	
	DW		(vstmxcsrInstr)	
	DW		(vucomisdInstr)	
	DW		(vucomissInstr)	
	DW		(vzeroallInstr)	
	DW		(xsaveoptInstr)	
EVEN 2
Keyword9:
	DW	000,000,000,007,007,008,008,008,008,009,009,009,009,009,009,009,022,022,022,024,024,024,093,093,093,093,093
	DW	Keyword9High, Keyword9Desc


Keyword9a:
Keyword9b:
Keyword9c:
	DW		0x928c	;cmpxchg8b low
	DW		0x1fe4	;cvttpd2dq low
	DW		0x4d4c	;cvttpd2pi low
	DW		0x034c	;cvttps2dq low
	DW		0xe97a	;cvttps2pi low
	DW		0x34a4	;cvttsd2si low
	DW		0x7880	;cvttss2si low
Keyword9d:
Keyword9e:
	DW		0x8472	;extractps low
Keyword9f:
Keyword9g:
Keyword9h:
Keyword9i:
	DW		0xcded	;includerc low
Keyword9j:
Keyword9k:
Keyword9l:
Keyword9m:
Keyword9n:
Keyword9o:
Keyword9p:
	DW		0xc30c	;pclmulqdq low
	DW		0xf3cb	;pcmpestri low
	DW		0x37d2	;pcmpestrm low
	DW		0xd641	;pcmpistri low
	DW		0x1258	;pcmpistrm low
	DW		0x0bed	;pmaddubsw low
	DW		0x0615	;prefetchw low
	DW		0x8fc4	;punpckhbw low
	DW		0xbb8d	;punpckhdq low
	DW		0x4a8c	;punpckhwd low
	DW		0x7c72	;punpcklbw low
	DW		0x1fed	;punpckldq low
	DW		0xd90b	;punpcklwd low
Keyword9q:
Keyword9r:
Keyword9s:
	DW		0xf9d2	;sha1nexte low
	DW		0xe382	;sha1rnds4 low
Keyword9t:
Keyword9u:
Keyword9v:
	DW		0x5990	;vaddsubpd low
	DW		0xbd7b	;vaddsubps low
	DW		0x12c5	;vblendvpd low
	DW		0x3237	;vblendvps low
	DW		0xf4f9	;vcvtdq2pd low
	DW		0x4c5d	;vcvtdq2ps low
	DW		0x823f	;vcvtpd2dq low
	DW		0x9173	;vcvtpd2ps low
	DW		0xfaa5	;vcvtph2ps low
	DW		0x54c9	;vcvtps2dq low
	DW		0x6777	;vcvtps2pd low
	DW		0x2b5c	;vcvtps2ph low
	DW		0x0230	;vcvtsd2si low
	DW		0x3f53	;vcvtsd2ss low
	DW		0x7258	;vcvtsi2sd low
	DW		0x52aa	;vcvtsi2ss low
	DW		0xa721	;vcvtss2sd low
	DW		0x7ea9	;vcvtss2si low
	DW		0xf20a	;vfnmaddpd low
	DW		0xd2f8	;vfnmaddps low
	DW		0xc34b	;vfnmaddsd low
	DW		0x27a0	;vfnmaddss low
	DW		0x5a25	;vfnmsubpd low
	DW		0xe281	;vfnmsubps low
	DW		0x8367	;vfnmsubsd low
	DW		0x2ba7	;vfnmsubss low
	DW		0xef41	;vinsertps low
	DW		0x4bb7	;vmovmskpd low
	DW		0xaf5c	;vmovmskps low
	DW		0xa499	;vmovntdqa low
	DW		0x70fa	;vmovshdup low
	DW		0xf7da	;vmovsldup low
	DW		0xb2de	;vpackssdw low
	DW		0xb021	;vpacksswb low
	DW		0x02c7	;vpackusdw low
	DW		0x0038	;vpackuswb low
	DW		0x6ae9	;vpblendvb low
	DW		0xa60f	;vpermilpd low
	DW		0x42e4	;vpermilps low
	DW		0x027c	;vphaddubd low
	DW		0x87bb	;vphaddubq low
	DW		0xe697	;vphaddubw low
	DW		0x4111	;vphaddudq low
	DW		0x43ee	;vphadduwd low
	DW		0x0230	;vphadduwq low
	DW		0x8a66	;vpmacsdqh low
	DW		0x4e7f	;vpmacsdql low
	DW		0x6cc5	;vpmacssdd low
	DW		0x03fe	;vpmacsswd low
	DW		0x230c	;vpmacssww low
	DW		0xab21	;vpmadcswd low
	DW		0xa21f	;vpmovmskb low
	DW		0x4cc9	;vpmovsxbd low
	DW		0xc90e	;vpmovsxbq low
	DW		0x10bc	;vpmovsxbw low
	DW		0x6daf	;vpmovsxdq low
	DW		0x6d6a	;vpmovsxwd low
	DW		0x2cb4	;vpmovsxwq low
	DW		0xc866	;vpmovzxbd low
	DW		0x4da1	;vpmovzxbq low
	DW		0xe894	;vpmovzxbw low
	DW		0x8b0b	;vpmovzxdq low
	DW		0x11ad	;vpmovzxwd low
	DW		0x946a	;vpmovzxwq low
	DW		0x40d8	;vpmulhrsw low
	DW		0x054e	;vunpckhpd low
	DW		0xe1a5	;vunpckhps low
	DW		0xcf10	;vunpcklpd low
	DW		0x2bfb	;vunpcklps low


Keyword9High:
	DW		0x7716	;cmpxchg8b high
	DW		0xc7e4	;cvttpd2dq high
	DW		0x3b47	;cvttpd2pi high
	DW		0x7ffb	;cvttps2dq high
	DW		0xab5a	;cvttps2pi high
	DW		0xdad0	;cvttsd2si high
	DW		0x7be0	;cvttss2si high
	DW		0x9775	;extractps high
	DW		0xfd0b	;includerc high
	DW		0x4a77	;pclmulqdq high
	DW		0x01d9	;pcmpestri high
	DW		0x06b4	;pcmpestrm high
	DW		0x6e20	;pcmpistri high
	DW		0x694d	;pcmpistrm high
	DW		0xa884	;pmaddubsw high
	DW		0xc7c0	;prefetchw high
	DW		0x27c4	;punpckhbw high
	DW		0x1b77	;punpckhdq high
	DW		0xa6f9	;punpckhwd high
	DW		0x4819	;punpcklbw high
	DW		0x192e	;punpckldq high
	DW		0x442b	;punpcklwd high
	DW		0xa917	;sha1nexte high
	DW		0x8cc2	;sha1rnds4 high
	DW		0x72ad	;vaddsubpd high
	DW		0x1f70	;vaddsubps high
	DW		0x8055	;vblendvpd high
	DW		0xeae5	;vblendvps high
	DW		0x86b0	;vcvtdq2pd high
	DW		0xff6c	;vcvtdq2ps high
	DW		0x1478	;vcvtpd2dq high
	DW		0x3dbb	;vcvtpd2ps high
	DW		0x74e9	;vcvtph2ps high
	DW		0x9958	;vcvtps2dq high
	DW		0xda2b	;vcvtps2pd high
	DW		0xd39d	;vcvtps2ph high
	DW		0x32a9	;vcvtsd2si high
	DW		0xc8a6	;vcvtsd2ss high
	DW		0x9df9	;vcvtsi2sd high
	DW		0xf749	;vcvtsi2ss high
	DW		0x906b	;vcvtss2sd high
	DW		0x07b9	;vcvtss2si high
	DW		0x1b2d	;vfnmaddpd high
	DW		0x719d	;vfnmaddps high
	DW		0x0236	;vfnmaddsd high
	DW		0x6feb	;vfnmaddss high
	DW		0x29de	;vfnmsubpd high
	DW		0x5002	;vfnmsubps high
	DW		0xb311	;vfnmsubsd high
	DW		0xd77a	;vfnmsubss high
	DW		0xe598	;vinsertps high
	DW		0xac30	;vmovmskpd high
	DW		0xc1ed	;vmovmskps high
	DW		0x4a28	;vmovntdqa high
	DW		0x716a	;vmovshdup high
	DW		0xfae1	;vmovsldup high
	DW		0xb8ca	;vpackssdw high
	DW		0xe2a2	;vpacksswb high
	DW		0x2055	;vpackusdw high
	DW		0x7a3d	;vpackuswb high
	DW		0xf7d1	;vpblendvb high
	DW		0xa33a	;vpermilpd high
	DW		0xcee7	;vpermilps high
	DW		0x790f	;vphaddubd high
	DW		0xfadc	;vphaddubq high
	DW		0x14d2	;vphaddubw high
	DW		0x4288	;vphaddudq high
	DW		0x18e0	;vphadduwd high
	DW		0x9c5e	;vphadduwq high
	DW		0x5633	;vpmacsdqh high
	DW		0x515e	;vpmacsdql high
	DW		0x9565	;vpmacssdd high
	DW		0xcf0a	;vpmacsswd high
	DW		0xa5ba	;vpmacssww high
	DW		0xfab4	;vpmadcswd high
	DW		0xd2bb	;vpmovmskb high
	DW		0x93fa	;vpmovsxbd high
	DW		0x1029	;vpmovsxbq high
	DW		0xd625	;vpmovsxbw high
	DW		0xe370	;vpmovsxdq high
	DW		0x7f1a	;vpmovsxwd high
	DW		0xfba4	;vpmovsxwq high
	DW		0x98c3	;vpmovzxbd high
	DW		0x1b10	;vpmovzxbq high
	DW		0xf273	;vpmovzxbw high
	DW		0xa344	;vpmovzxdq high
	DW		0x7b37	;vpmovzxwd high
	DW		0xf8e4	;vpmovzxwq high
	DW		0x2b2a	;vpmulhrsw high
	DW		0x183c	;vunpckhpd high
	DW		0x75e1	;vunpckhps high
	DW		0x2d03	;vunpcklpd high
	DW		0x40de	;vunpcklps high


Keyword9Desc:
	DW		(cmpxchg8bInstr)	
	DW		(cvttpd2dqInstr)	
	DW		(cvttpd2piInstr)	
	DW		(cvttps2dqInstr)	
	DW		(cvttps2piInstr)	
	DW		(cvttsd2siInstr)	
	DW		(cvttss2siInstr)	
	DW		(extractpsInstr)	
	DW		(IncludeRCDirective)	
	DW		(pclmulqdqInstr)	
	DW		(pcmpestriInstr)	
	DW		(pcmpestrmInstr)	
	DW		(pcmpistriInstr)	
	DW		(pcmpistrmInstr)	
	DW		(pmaddubswInstr)	
	DW		(prefetchwInstr)	
	DW		(punpckhbwInstr)	
	DW		(punpckhdqInstr)	
	DW		(punpckhwdInstr)	
	DW		(punpcklbwInstr)	
	DW		(punpckldqInstr)	
	DW		(punpcklwdInstr)	
	DW		(sha1nexteInstr)	
	DW		(sha1rnds4Instr)	
	DW		(vaddsubpdInstr)	
	DW		(vaddsubpsInstr)	
	DW		(vblendvpdInstr)	
	DW		(vblendvpsInstr)	
	DW		(vcvtdq2pdInstr)	
	DW		(vcvtdq2psInstr)	
	DW		(vcvtpd2dqInstr)	
	DW		(vcvtpd2psInstr)	
	DW		(vcvtph2psInstr)	
	DW		(vcvtps2dqInstr)	
	DW		(vcvtps2pdInstr)	
	DW		(vcvtps2phInstr)	
	DW		(vcvtsd2siInstr)	
	DW		(vcvtsd2ssInstr)	
	DW		(vcvtsi2sdInstr)	
	DW		(vcvtsi2ssInstr)	
	DW		(vcvtss2sdInstr)	
	DW		(vcvtss2siInstr)	
	DW		(vfnmaddpdInstr)	
	DW		(vfnmaddpsInstr)	
	DW		(vfnmaddsdInstr)	
	DW		(vfnmaddssInstr)	
	DW		(vfnmsubpdInstr)	
	DW		(vfnmsubpsInstr)	
	DW		(vfnmsubsdInstr)	
	DW		(vfnmsubssInstr)	
	DW		(vinsertpsInstr)	
	DW		(vmovmskpdInstr)	
	DW		(vmovmskpsInstr)	
	DW		(vmovntdqaInstr)	
	DW		(vmovshdupInstr)	
	DW		(vmovsldupInstr)	
	DW		(vpackssdwInstr)	
	DW		(vpacksswbInstr)	
	DW		(vpackusdwInstr)	
	DW		(vpackuswbInstr)	
	DW		(vpblendvbInstr)	
	DW		(vpermilpdInstr)	
	DW		(vpermilpsInstr)	
	DW		(vphaddubdInstr)	
	DW		(vphaddubqInstr)	
	DW		(vphaddubwInstr)	
	DW		(vphaddudqInstr)	
	DW		(vphadduwdInstr)	
	DW		(vphadduwqInstr)	
	DW		(vpmacsdqhInstr)	
	DW		(vpmacsdqlInstr)	
	DW		(vpmacssddInstr)	
	DW		(vpmacsswdInstr)	
	DW		(vpmacsswwInstr)	
	DW		(vpmadcswdInstr)	
	DW		(vpmovmskbInstr)	
	DW		(vpmovsxbdInstr)	
	DW		(vpmovsxbqInstr)	
	DW		(vpmovsxbwInstr)	
	DW		(vpmovsxdqInstr)	
	DW		(vpmovsxwdInstr)	
	DW		(vpmovsxwqInstr)	
	DW		(vpmovzxbdInstr)	
	DW		(vpmovzxbqInstr)	
	DW		(vpmovzxbwInstr)	
	DW		(vpmovzxdqInstr)	
	DW		(vpmovzxwdInstr)	
	DW		(vpmovzxwqInstr)	
	DW		(vpmulhrswInstr)	
	DW		(vunpckhpdInstr)	
	DW		(vunpckhpsInstr)	
	DW		(vunpcklpdInstr)	
	DW		(vunpcklpsInstr)	
EVEN 2
Keyword10:
	DW	000,002,002,007,007,007,007,007,007,009,009,009,009,010,010,010,016,016,016,018,018,018,055,055,055,055,055
	DW	Keyword10High, Keyword10Desc


Keyword10a:
	DW		0x0ca2	;aesdeclast low
	DW		0xcf9e	;aesenclast low
Keyword10b:
Keyword10c:
	DW		0xd71b	;cmpunordpd low
	DW		0xf7e9	;cmpunordps low
	DW		0xe65a	;cmpunordsd low
	DW		0x02b1	;cmpunordss low
	DW		0x5494	;cmpxchg16b low
Keyword10d:
Keyword10e:
Keyword10f:
Keyword10g:
Keyword10h:
Keyword10i:
	DW		0xc030	;includebin low
	DW		0xa198	;includelib low
Keyword10j:
Keyword10k:
Keyword10l:
Keyword10m:
	DW		0x3c68	;maskmovdqu low
Keyword10n:
Keyword10o:
Keyword10p:
	DW		0xebb5	;phminposuw low
	DW		0xb0a3	;prefetcht0 low
	DW		0x2500	;prefetcht1 low
	DW		0x1596	;prefetcht2 low
	DW		0x744a	;punpckhqdq low
	DW		0xdd0b	;punpcklqdq low
Keyword10q:
Keyword10r:
Keyword10s:
	DW		0x1fef	;sha256msg1 low
	DW		0xeb60	;sha256msg2 low
Keyword10t:
Keyword10u:
Keyword10v:
	DW		0x6f3d	;vcvttpd2dq low
	DW		0xb78c	;vcvttps2dq low
	DW		0x7fd6	;vcvttsd2si low
	DW		0x9ccc	;vcvttss2si low
	DW		0x1828	;vextractps low
	DW		0x203a	;vgatherdpd low
	DW		0xc4d1	;vgatherdps low
	DW		0x5365	;vgatherqpd low
	DW		0xb78e	;vgatherqps low
	DW		0xd094	;vmaskmovpd low
	DW		0x347f	;vmaskmovps low
	DW		0xab59	;vpclmulqdq low
	DW		0xd7e6	;vpcmpestri low
	DW		0x13ff	;vpcmpestrm low
	DW		0x8f94	;vpcmpistri low
	DW		0xc3bf	;vpcmpistrm low
	DW		0xad5d	;vperm2f128 low
	DW		0xbec7	;vperm2i128 low
	DW		0x048d	;vpermil2pd low
	DW		0xac4d	;vpermil2ps low
	DW		0x73ab	;vpgatherdd low
	DW		0x3275	;vpgatherdq low
	DW		0x9611	;vpgatherqd low
	DW		0x13d6	;vpgatherqq low
	DW		0x2019	;vpmacssdqh low
	DW		0xe400	;vpmacssdql low
	DW		0x9760	;vpmadcsswd low
	DW		0xbb85	;vpmaddubsw low
	DW		0x5af9	;vpmaskmovd low
	DW		0x9315	;vpmaskmovq low
	DW		0x47ea	;vpunpckhbw low
	DW		0x3ca6	;vpunpckhdq low
	DW		0x82a2	;vpunpckhwd low
	DW		0x8db4	;vpunpcklbw low
	DW		0xee2b	;vpunpckldq low
	DW		0x48fc	;vpunpcklwd low
	DW		0x1818	;vzeroupper low


Keyword10High:
	DW		0x48d5	;aesdeclast high
	DW		0x96f1	;aesenclast high
	DW		0x7005	;cmpunordpd high
	DW		0x1ab5	;cmpunordps high
	DW		0x691e	;cmpunordsd high
	DW		0x04c3	;cmpunordss high
	DW		0xd77f	;cmpxchg16b high
	DW		0xae8f	;includebin high
	DW		0xd49c	;includelib high
	DW		0xb064	;maskmovdqu high
	DW		0xfd30	;phminposuw high
	DW		0xccbc	;prefetcht0 high
	DW		0x52d8	;prefetcht1 high
	DW		0x25df	;prefetcht2 high
	DW		0x65ae	;punpckhqdq high
	DW		0x0cce	;punpcklqdq high
	DW		0xb4e5	;sha256msg1 high
	DW		0xc48f	;sha256msg2 high
	DW		0x0192	;vcvttpd2dq high
	DW		0xbee0	;vcvttps2dq high
	DW		0xa2d6	;vcvttsd2si high
	DW		0xa3d4	;vcvttss2si high
	DW		0x646d	;vextractps high
	DW		0xe1c3	;vgatherdpd high
	DW		0x8c1e	;vgatherdps high
	DW		0x40fe	;vgatherqpd high
	DW		0x2d23	;vgatherqps high
	DW		0x05be	;vmaskmovpd high
	DW		0x6863	;vmaskmovps high
	DW		0x9cc1	;vpclmulqdq high
	DW		0x871b	;vpcmpestri high
	DW		0x8076	;vpcmpestrm high
	DW		0x5eed	;vpcmpistri high
	DW		0x575b	;vpcmpistrm high
	DW		0x9563	;vperm2f128 high
	DW		0xa842	;vperm2i128 high
	DW		0xd77e	;vpermil2pd high
	DW		0xb315	;vpermil2ps high
	DW		0x55b2	;vpgatherdd high
	DW		0xd10c	;vpgatherdq high
	DW		0xbe3f	;vpgatherqd high
	DW		0x3dec	;vpgatherqq high
	DW		0x98cd	;vpmacssdqh high
	DW		0x9fa0	;vpmacssdql high
	DW		0xbb18	;vpmadcsswd high
	DW		0x1a31	;vpmaddubsw high
	DW		0x6964	;vpmaskmovd high
	DW		0xe301	;vpmaskmovq high
	DW		0xc85c	;vpunpckhbw high
	DW		0x0496	;vpunpckhdq high
	DW		0x4961	;vpunpckhwd high
	DW		0xfd63	;vpunpcklbw high
	DW		0xac54	;vpunpckldq high
	DW		0x7c5e	;vpunpcklwd high
	DW		0xec17	;vzeroupper high


Keyword10Desc:
	DW		(aesdeclastInstr)	
	DW		(aesenclastInstr)	
	DW		(cmpunordpdInstr)	
	DW		(cmpunordpsInstr)	
	DW		(cmpunordsdInstr)	
	DW		(cmpunordssInstr)	
	DW		(CmpXChg16BInstr)	
	DW		(IncludeBinDirective)	
	DW		(IncludeLibDirective)	
	DW		(maskmovdquInstr)	
	DW		(phminposuwInstr)	
	DW		(prefetcht0Instr)	
	DW		(prefetcht1Instr)	
	DW		(prefetcht2Instr)	
	DW		(punpckhqdqInstr)	
	DW		(punpcklqdqInstr)	
	DW		(sha256msg1Instr)	
	DW		(sha256msg2Instr)	
	DW		(vcvttpd2dqInstr)	
	DW		(vcvttps2dqInstr)	
	DW		(vcvttsd2siInstr)	
	DW		(vcvttss2siInstr)	
	DW		(vextractpsInstr)	
	DW		(vgatherdpdInstr)	
	DW		(vgatherdpsInstr)	
	DW		(vgatherqpdInstr)	
	DW		(vgatherqpsInstr)	
	DW		(vmaskmovpdInstr)	
	DW		(vmaskmovpsInstr)	
	DW		(vpclmulqdqInstr)	
	DW		(vpcmpestriInstr)	
	DW		(vpcmpestrmInstr)	
	DW		(vpcmpistriInstr)	
	DW		(vpcmpistrmInstr)	
	DW		(vperm2f128Instr)	
	DW		(vperm2i128Instr)	
	DW		(vpermil2pdInstr)	
	DW		(vpermil2psInstr)	
	DW		(vpgatherddInstr)	
	DW		(vpgatherdqInstr)	
	DW		(vpgatherqdInstr)	
	DW		(vpgatherqqInstr)	
	DW		(vpmacssdqhInstr)	
	DW		(vpmacssdqlInstr)	
	DW		(vpmadcsswdInstr)	
	DW		(vpmaddubswInstr)	
	DW		(vpmaskmovdInstr)	
	DW		(vpmaskmovqInstr)	
	DW		(vpunpckhbwInstr)	
	DW		(vpunpckhdqInstr)	
	DW		(vpunpckhwdInstr)	
	DW		(vpunpcklbwInstr)	
	DW		(vpunpckldqInstr)	
	DW		(vpunpcklwdInstr)	
	DW		(vzeroupperInstr)	
EVEN 2
Keyword11:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,001,001,001,002,002,002,038,038,038,038,038
	DW	Keyword11High, Keyword11Desc


Keyword11a:
Keyword11b:
Keyword11c:
Keyword11d:
Keyword11e:
Keyword11f:
Keyword11g:
Keyword11h:
Keyword11i:
Keyword11j:
Keyword11k:
Keyword11l:
Keyword11m:
Keyword11n:
Keyword11o:
Keyword11p:
	DW		0xed6b	;prefetchnta low
Keyword11q:
Keyword11r:
Keyword11s:
	DW		0xdd95	;sha256rnds2 low
Keyword11t:
Keyword11u:
Keyword11v:
	DW		0x06b7	;vaesdeclast low
	DW		0x7673	;vaesenclast low
	DW		0xf425	;vfmadd132pd low
	DW		0xd4d7	;vfmadd132ps low
	DW		0xeb44	;vfmadd132sd low
	DW		0x0faf	;vfmadd132ss low
	DW		0x77f8	;vfmadd213pd low
	DW		0x570a	;vfmadd213ps low
	DW		0x46b9	;vfmadd213sd low
	DW		0xa252	;vfmadd213ss low
	DW		0x6b1d	;vfmadd231pd low
	DW		0x31c0	;vfmadd231ps low
	DW		0xb25f	;vfmadd231sd low
	DW		0x1a9f	;vfmadd231ss low
	DW		0xde8c	;vfmaddsubpd low
	DW		0x3a67	;vfmaddsubps low
	DW		0x13d1	;vfmsub132pd low
	DW		0xf73a	;vfmsub132ps low
	DW		0xc8a9	;vfmsub132sd low
	DW		0xe85b	;vfmsub132ss low
	DW		0xdb18	;vfmsub213pd low
	DW		0x3ff3	;vfmsub213ps low
	DW		0xea59	;vfmsub213sd low
	DW		0xcaab	;vfmsub213ss low
	DW		0x9936	;vfmsub231pd low
	DW		0xb9c4	;vfmsub231ps low
	DW		0xa877	;vfmsub231sd low
	DW		0x4c9c	;vfmsub231ss low
	DW		0xc9e2	;vfmsubaddpd low
	DW		0xe910	;vfmsubaddps low
	DW		0xd35b	;vinsertf128 low
	DW		0xbe4d	;vinserti128 low
	DW		0xacbb	;vmaskmovdqu low
	DW		0xd952	;vphminposuw low
	DW		0xad66	;vpunpckhqdq low
	DW		0x784e	;vpunpcklqdq low


Keyword11High:
	DW		0x3858	;prefetchnta high
	DW		0x052a	;sha256rnds2 high
	DW		0xfa83	;vaesdeclast high
	DW		0x88cb	;vaesenclast high
	DW		0xf881	;vfmadd132pd high
	DW		0x9231	;vfmadd132ps high
	DW		0xa321	;vfmadd132sd high
	DW		0xcefc	;vfmadd132ss high
	DW		0x70d2	;vfmadd213pd high
	DW		0x1a62	;vfmadd213ps high
	DW		0x69c9	;vfmadd213sd high
	DW		0x0414	;vfmadd213ss high
	DW		0xd95f	;vfmadd231pd high
	DW		0x0089	;vfmadd231ps high
	DW		0x4390	;vfmadd231sd high
	DW		0x27fb	;vfmadd231ss high
	DW		0x1689	;vfmaddsubpd high
	DW		0x7b54	;vfmaddsubps high
	DW		0xe656	;vfmsub132pd high
	DW		0x8b8b	;vfmsub132ps high
	DW		0xba9b	;vfmsub132sd high
	DW		0xd02b	;vfmsub132ss high
	DW		0xb1f7	;vfmsub213pd high
	DW		0xdc2a	;vfmsub213ps high
	DW		0xa8ec	;vfmsub213sd high
	DW		0xc25c	;vfmsub213ss high
	DW		0x3307	;vfmsub231pd high
	DW		0x59b7	;vfmsub231ps high
	DW		0x2a1c	;vfmsub231sd high
	DW		0x47c1	;vfmsub231ss high
	DW		0xe47f	;vfmsubaddpd high
	DW		0x8ecf	;vfmsubaddps high
	DW		0xbea5	;vinsertf128 high
	DW		0xd87e	;vinserti128 high
	DW		0x4df4	;vmaskmovdqu high
	DW		0x9967	;vphminposuw high
	DW		0xb021	;vpunpckhqdq high
	DW		0x1df9	;vpunpcklqdq high


Keyword11Desc:
	DW		(prefetchntaInstr)	
	DW		(sha256rnds2Instr)	
	DW		(vaesdeclastInstr)	
	DW		(vaesenclastInstr)	
	DW		(vfmadd132pdInstr)	
	DW		(vfmadd132psInstr)	
	DW		(vfmadd132sdInstr)	
	DW		(vfmadd132ssInstr)	
	DW		(vfmadd213pdInstr)	
	DW		(vfmadd213psInstr)	
	DW		(vfmadd213sdInstr)	
	DW		(vfmadd213ssInstr)	
	DW		(vfmadd231pdInstr)	
	DW		(vfmadd231psInstr)	
	DW		(vfmadd231sdInstr)	
	DW		(vfmadd231ssInstr)	
	DW		(vfmaddsubpdInstr)	
	DW		(vfmaddsubpsInstr)	
	DW		(vfmsub132pdInstr)	
	DW		(vfmsub132psInstr)	
	DW		(vfmsub132sdInstr)	
	DW		(vfmsub132ssInstr)	
	DW		(vfmsub213pdInstr)	
	DW		(vfmsub213psInstr)	
	DW		(vfmsub213sdInstr)	
	DW		(vfmsub213ssInstr)	
	DW		(vfmsub231pdInstr)	
	DW		(vfmsub231psInstr)	
	DW		(vfmsub231sdInstr)	
	DW		(vfmsub231ssInstr)	
	DW		(vfmsubaddpdInstr)	
	DW		(vfmsubaddpsInstr)	
	DW		(vinsertf128Instr)	
	DW		(vinserti128Instr)	
	DW		(vmaskmovdquInstr)	
	DW		(vphminposuwInstr)	
	DW		(vpunpckhqdqInstr)	
	DW		(vpunpcklqdqInstr)	
EVEN 2
Keyword12:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,032,032,032,032,032
	DW	Keyword12High, Keyword12Desc


Keyword12a:
Keyword12b:
Keyword12c:
Keyword12d:
Keyword12e:
Keyword12f:
Keyword12g:
Keyword12h:
Keyword12i:
Keyword12j:
Keyword12k:
Keyword12l:
Keyword12m:
Keyword12n:
Keyword12o:
Keyword12p:
Keyword12q:
Keyword12r:
Keyword12s:
Keyword12t:
Keyword12u:
Keyword12v:
	DW		0x1ee7	;vbroadcastsd low
	DW		0x3e15	;vbroadcastss low
	DW		0xaf95	;vextractf128 low
	DW		0x3699	;vextracti128 low
	DW		0x707c	;vfnmadd132pd low
	DW		0x508e	;vfnmadd132ps low
	DW		0x8524	;vfnmadd132sd low
	DW		0x61cf	;vfnmadd132ss low
	DW		0xc7c1	;vfnmadd213pd low
	DW		0x232a	;vfnmadd213ps low
	DW		0x1cb9	;vfnmadd213sd low
	DW		0x3c4b	;vfnmadd213ss low
	DW		0x7194	;vfnmadd231pd low
	DW		0xc930	;vfnmadd231ps low
	DW		0x1c9a	;vfnmadd231sd low
	DW		0xf871	;vfnmadd231ss low
	DW		0x9946	;vfnmsub132pd low
	DW		0x3186	;vfnmsub132ps low
	DW		0xa807	;vfnmsub132sd low
	DW		0x4cec	;vfnmsub132ss low
	DW		0x70c8	;vfnmsub213pd low
	DW		0x9423	;vfnmsub213ps low
	DW		0x4189	;vfnmsub213sd low
	DW		0xe949	;vfnmsub213ss low
	DW		0x6c2d	;vfnmsub231pd low
	DW		0x88c6	;vfnmsub231ps low
	DW		0xf944	;vfnmsub231sd low
	DW		0x1daf	;vfnmsub231ss low
	DW		0xbb88	;vpbroadcastb low
	DW		0x42f2	;vpbroadcastd low
	DW		0xc735	;vpbroadcastq low
	DW		0x6200	;vpbroadcastw low


Keyword12High:
	DW		0x0959	;vbroadcastsd high
	DW		0x63e9	;vbroadcastss high
	DW		0x1db1	;vextractf128 high
	DW		0x1159	;vextracti128 high
	DW		0x4a74	;vfnmadd132pd high
	DW		0x20c4	;vfnmadd132ps high
	DW		0x5402	;vfnmadd132sd high
	DW		0x39df	;vfnmadd132ss high
	DW		0x183f	;vfnmadd213pd high
	DW		0x75e2	;vfnmadd213ps high
	DW		0x44f2	;vfnmadd213sd high
	DW		0x2e42	;vfnmadd213ss high
	DW		0x50c2	;vfnmadd231pd high
	DW		0x291e	;vfnmadd231ps high
	DW		0x5dd8	;vfnmadd231sd high
	DW		0x3005	;vfnmadd231ss high
	DW		0xbc57	;vfnmsub132pd high
	DW		0xd83c	;vfnmsub132ps high
	DW		0xa54c	;vfnmsub132sd high
	DW		0xc891	;vfnmsub132ss high
	DW		0x18ca	;vfnmsub213pd high
	DW		0x7517	;vfnmsub213ps high
	DW		0x01d1	;vfnmsub213sd high
	DW		0x65ba	;vfnmsub213ss high
	DW		0xb147	;vfnmsub231pd high
	DW		0xdc9a	;vfnmsub231ps high
	DW		0x223e	;vfnmsub231sd high
	DW		0x4fe3	;vfnmsub231ss high
	DW		0x1d82	;vpbroadcastb high
	DW		0xe0e0	;vpbroadcastd high
	DW		0x6333	;vpbroadcastq high
	DW		0x8a50	;vpbroadcastw high


Keyword12Desc:
	DW		(vbroadcastsdInstr)	
	DW		(vbroadcastssInstr)	
	DW		(vextractf128Instr)	
	DW		(vextracti128Instr)	
	DW		(vfnmadd132pdInstr)	
	DW		(vfnmadd132psInstr)	
	DW		(vfnmadd132sdInstr)	
	DW		(vfnmadd132ssInstr)	
	DW		(vfnmadd213pdInstr)	
	DW		(vfnmadd213psInstr)	
	DW		(vfnmadd213sdInstr)	
	DW		(vfnmadd213ssInstr)	
	DW		(vfnmadd231pdInstr)	
	DW		(vfnmadd231psInstr)	
	DW		(vfnmadd231sdInstr)	
	DW		(vfnmadd231ssInstr)	
	DW		(vfnmsub132pdInstr)	
	DW		(vfnmsub132psInstr)	
	DW		(vfnmsub132sdInstr)	
	DW		(vfnmsub132ssInstr)	
	DW		(vfnmsub213pdInstr)	
	DW		(vfnmsub213psInstr)	
	DW		(vfnmsub213sdInstr)	
	DW		(vfnmsub213ssInstr)	
	DW		(vfnmsub231pdInstr)	
	DW		(vfnmsub231psInstr)	
	DW		(vfnmsub231sdInstr)	
	DW		(vfnmsub231ssInstr)	
	DW		(vpbroadcastbInstr)	
	DW		(vpbroadcastdInstr)	
	DW		(vpbroadcastqInstr)	
	DW		(vpbroadcastwInstr)	
EVEN 2
Keyword13:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
	DW	Keyword13High, Keyword13Desc




Keyword13High:


Keyword13Desc:
EVEN 2
Keyword14:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,014,014,014,014,014
	DW	Keyword14High, Keyword14Desc


Keyword14a:
Keyword14b:
Keyword14c:
Keyword14d:
Keyword14e:
Keyword14f:
Keyword14g:
Keyword14h:
Keyword14i:
Keyword14j:
Keyword14k:
Keyword14l:
Keyword14m:
Keyword14n:
Keyword14o:
Keyword14p:
Keyword14q:
Keyword14r:
Keyword14s:
Keyword14t:
Keyword14u:
Keyword14v:
	DW		0xfff0	;vbroadcastf128 low
	DW		0x9b3b	;vbroadcasti128 low
	DW		0xa968	;vfmaddsub132pd low
	DW		0x899a	;vfmaddsub132ps low
	DW		0x3fdf	;vfmaddsub213pd low
	DW		0xdb34	;vfmaddsub213ps low
	DW		0x14a3	;vfmaddsub231pd low
	DW		0xac07	;vfmaddsub231ps low
	DW		0x502b	;vfmsubadd132pd low
	DW		0x89d7	;vfmsubadd132ps low
	DW		0x6e09	;vfmsubadd213pd low
	DW		0x8ae2	;vfmsubadd213ps low
	DW		0x31d5	;vfmsubadd231pd low
	DW		0x9915	;vfmsubadd231ps low


Keyword14High:
	DW		0x7584	;vbroadcastf128 high
	DW		0x1100	;vbroadcasti128 high
	DW		0x937f	;vfmaddsub132pd high
	DW		0xf9cf	;vfmaddsub132ps high
	DW		0x9fd2	;vfmaddsub213pd high
	DW		0xf20f	;vfmaddsub213ps high
	DW		0x6b0c	;vfmaddsub231pd high
	DW		0x12d0	;vfmaddsub231ps high
	DW		0x422a	;vfmsubadd132pd high
	DW		0x7644	;vfmsubadd132ps high
	DW		0x7413	;vfmsubadd213pd high
	DW		0x19ce	;vfmsubadd213ps high
	DW		0x5178	;vfmsubadd231pd high
	DW		0x3513	;vfmsubadd231ps high


Keyword14Desc:
	DW		(vbroadcastf128Instr)	
	DW		(vbroadcasti128Instr)	
	DW		(vfmaddsub132pdInstr)	
	DW		(vfmaddsub132psInstr)	
	DW		(vfmaddsub213pdInstr)	
	DW		(vfmaddsub213psInstr)	
	DW		(vfmaddsub231pdInstr)	
	DW		(vfmaddsub231psInstr)	
	DW		(vfmsubadd132pdInstr)	
	DW		(vfmsubadd132psInstr)	
	DW		(vfmsubadd213pdInstr)	
	DW		(vfmsubadd213psInstr)	
	DW		(vfmsubadd231pdInstr)	
	DW		(vfmsubadd231psInstr)	
EVEN 2
Keyword15:
	DW	000,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001
	DW	Keyword15High, Keyword15Desc


Keyword15a:
	DW		0x2428	;aeskeygenassist low


Keyword15High:
	DW		0x3762	;aeskeygenassist high


Keyword15Desc:
	DW		(aeskeygenassistInstr)	
EVEN 2
Keyword16:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,001,001,001,001,001
	DW	Keyword16High, Keyword16Desc


Keyword16a:
Keyword16b:
Keyword16c:
Keyword16d:
Keyword16e:
Keyword16f:
Keyword16g:
Keyword16h:
Keyword16i:
Keyword16j:
Keyword16k:
Keyword16l:
Keyword16m:
Keyword16n:
Keyword16o:
Keyword16p:
Keyword16q:
Keyword16r:
Keyword16s:
Keyword16t:
Keyword16u:
Keyword16v:
	DW		0xb4f8	;vaeskeygenassist low


Keyword16High:
	DW		0x40a4	;vaeskeygenassist high


Keyword16Desc:
	DW		(vaeskeygenassistInstr)	
EVEN 2
Keyword17:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
	DW	Keyword17High, Keyword17Desc




Keyword17High:


Keyword17Desc:
EVEN 2
Keyword18:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
	DW	Keyword18High, Keyword18Desc




Keyword18High:


Keyword18Desc:
EVEN 2
Keyword19:
	DW	000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
	DW	Keyword19High, Keyword19Desc




Keyword19High:


Keyword19Desc:

