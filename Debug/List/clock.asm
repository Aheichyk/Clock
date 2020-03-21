
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _hour=R5
	.DEF _min=R4
	.DEF _sec=R7
	.DEF _week=R6
	.DEF _day=R9
	.DEF _mon=R8
	.DEF _year=R11
	.DEF _ring_set=R10
	.DEF _bt_set=R12
	.DEF _bt_set_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x0:
	.DB  0x53,0x65,0x74,0x3A,0x6D,0x6F,0x64,0x65
	.DB  0x3A,0x25,0x64,0xD,0x0,0x53,0x65,0x74
	.DB  0x75,0x70,0xD,0x0,0x77,0x25,0x64,0x5F
	.DB  0x25,0x64,0x3A,0x25,0x64,0x3A,0x25,0x64
	.DB  0xD,0x0,0x73,0x65,0x74,0x5F,0x6D,0x6F
	.DB  0x64,0x65,0x3A,0x25,0x64,0x3A,0x20,0x77
	.DB  0x25,0x64,0x5F,0x25,0x64,0x3A,0x25,0x64
	.DB  0x3A,0x25,0x64,0xD,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0C
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// I2C Bus functions
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;#define HOUR_M 1
;#define MIN_M 2
;#define SEC_M 3
;#define WEEK_M 4
;unsigned char hour,min,sec,week,day,mon,year,ring_set;
;unsigned int bt_set=0;
;unsigned int get_time=0;
;unsigned char set_mode=0;
;unsigned char set;
;unsigned char mode;
;unsigned char ring;
;unsigned char ring_disp=0;
;
;
;
;void WriteEeprom(unsigned int addr, unsigned char data) {
; 0000 001C void WriteEeprom(unsigned int addr, unsigned char data) {

	.CSEG
_WriteEeprom:
; .FSTART _WriteEeprom
; 0000 001D   /* Wait for completion of previous write */
; 0000 001E   while(EECR & (1<<EEWE));
	ST   -Y,R26
;	addr -> Y+1
;	data -> Y+0
_0x3:
	SBIC 0x1C,1
	RJMP _0x3
; 0000 001F   /* Set up address and data registers */
; 0000 0020   EEAR = addr;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 0021   EEDR = data;
	LD   R30,Y
	OUT  0x1D,R30
; 0000 0022   /* Write logical one to EEMWE */
; 0000 0023   EECR |= (1<<EEMWE);
	SBI  0x1C,2
; 0000 0024   /* Start eeprom write by setting EEWE */
; 0000 0025   EECR |= (1<<EEWE);
	SBI  0x1C,1
; 0000 0026 }
	RJMP _0x20A0001
; .FEND
;
;unsigned char ReadEeprom(unsigned int addr) {
; 0000 0028 unsigned char ReadEeprom(unsigned int addr) {
_ReadEeprom:
; .FSTART _ReadEeprom
; 0000 0029   /* Wait for completion of previous write */
; 0000 002A   while(EECR & (1<<EEWE));
	RCALL SUBOPT_0x0
;	addr -> Y+0
_0x6:
	SBIC 0x1C,1
	RJMP _0x6
; 0000 002B   /* Set up address register */
; 0000 002C   EEAR = addr;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 002D   /* Start eeprom read by writing EERE */
; 0000 002E   EECR |= (1<<EERE);
	SBI  0x1C,0
; 0000 002F   /* Return data from data register */
; 0000 0030   return EEDR;
	IN   R30,0x1D
	RJMP _0x20A0002
; 0000 0031 }
; .FEND
;
;void buzzer() {
; 0000 0033 void buzzer() {
_buzzer:
; .FSTART _buzzer
; 0000 0034     static unsigned char old_min;
; 0000 0035     if (old_min != min) {
	LDS  R26,_old_min_S0000002000
	CP   R4,R26
	BREQ _0x9
; 0000 0036         // Check buzzer every minute
; 0000 0037         if (ReadEeprom((week-1)*3)) {
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	CPI  R30,0
	BREQ _0xA
; 0000 0038             // Ring was set
; 0000 0039             unsigned char ring_hour = ReadEeprom((week-1)*3+2);
; 0000 003A             if (ring_hour == hour) {
	SBIW R28,1
;	ring_hour -> Y+0
	RCALL SUBOPT_0x1
	ADIW R30,2
	RCALL SUBOPT_0x2
	ST   Y,R30
	LD   R26,Y
	CP   R5,R26
	BRNE _0xB
; 0000 003B                 unsigned char ring_min = ReadEeprom((week-1)*3+1);
; 0000 003C                 if (ring_min == min) {
	SBIW R28,1
;	ring_hour -> Y+1
;	ring_min -> Y+0
	RCALL SUBOPT_0x1
	ADIW R30,1
	RCALL SUBOPT_0x2
	ST   Y,R30
; 0000 003D                     // BUZZER!!!!! pi pi pi pi
; 0000 003E                 }
; 0000 003F             }
	ADIW R28,1
; 0000 0040         }
_0xB:
	ADIW R28,1
; 0000 0041     }
_0xA:
; 0000 0042     old_min = min;
_0x9:
	STS  _old_min_S0000002000,R4
; 0000 0043 }
	RET
; .FEND
;
;void set_button() {
; 0000 0045 void set_button() {
_set_button:
; .FSTART _set_button
; 0000 0046     // Long & One touch
; 0000 0047     printf("Set:mode:%d\r",set_mode);
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 0048     if (set_mode==HOUR_M) {
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x1)
	BRNE _0xD
; 0000 0049         hour++;
	INC  R5
; 0000 004A         if (hour > 23) hour=0;
	LDI  R30,LOW(23)
	CP   R30,R5
	BRSH _0xE
	CLR  R5
; 0000 004B     } else if (set_mode==MIN_M) {
_0xE:
	RJMP _0xF
_0xD:
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x2)
	BRNE _0x10
; 0000 004C         min++;
	INC  R4
; 0000 004D         if (min > 59)  min=0;
	LDI  R30,LOW(59)
	CP   R30,R4
	BRSH _0x11
	CLR  R4
; 0000 004E     } else if (set_mode==SEC_M) {
_0x11:
	RJMP _0x12
_0x10:
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x3)
	BRNE _0x13
; 0000 004F         sec++;
	INC  R7
; 0000 0050         if (sec > 59) sec=0;
	LDI  R30,LOW(59)
	CP   R30,R7
	BRSH _0x14
	CLR  R7
; 0000 0051     } else if (set_mode==WEEK_M) {
_0x14:
	RJMP _0x15
_0x13:
	RCALL SUBOPT_0x7
	BRNE _0x16
; 0000 0052         week++;
	INC  R6
; 0000 0053         if (week > 7) week=1;
	LDI  R30,LOW(7)
	CP   R30,R6
	BRSH _0x17
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0054     } else if (ring_disp) {
_0x17:
	RJMP _0x18
_0x16:
	RCALL SUBOPT_0x8
	BREQ _0x19
; 0000 0055         ring_set = !ring_set;
	MOV  R30,R10
	RCALL __LNEGB1
	MOV  R10,R30
; 0000 0056     }
; 0000 0057 }
_0x19:
_0x18:
_0x15:
_0x12:
_0xF:
	RET
; .FEND
;
;void mode_button() {
; 0000 0059 void mode_button() {
_mode_button:
; .FSTART _mode_button
; 0000 005A     // One touch
; 0000 005B     printf("Setup\r");
	__POINTW1FN _0x0,13
	RCALL SUBOPT_0x3
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 005C     set_mode++; // Setup clock mode 0 - None,1-Hour,2-Min,3-Sec,4-week
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x9
; 0000 005D     if (!ring_disp) {
	RCALL SUBOPT_0x8
	BRNE _0x1A
; 0000 005E         if (set_mode > WEEK_M) {
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x5)
	BRLO _0x1B
; 0000 005F             set_mode=0;
	RCALL SUBOPT_0xA
; 0000 0060             rtc_set_time(hour,min,sec);
	ST   -Y,R5
	ST   -Y,R4
	MOV  R26,R7
	RCALL _rtc_set_time
; 0000 0061             rtc_set_date(week,day,mon,year);
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	MOV  R26,R11
	RCALL _rtc_set_date
; 0000 0062         }
; 0000 0063     } else if (ring_disp) {
_0x1B:
	RJMP _0x1C
_0x1A:
	RCALL SUBOPT_0x8
	BREQ _0x1D
; 0000 0064         if (set_mode > MIN_M) {
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x3)
	BRLO _0x1E
; 0000 0065             set_mode=0;
	RCALL SUBOPT_0xA
; 0000 0066             // Save ring settings to eeprom
; 0000 0067             WriteEeprom((ring_disp-1)*3+1,min);
	RCALL SUBOPT_0xB
	ADIW R30,1
	RCALL SUBOPT_0x3
	MOV  R26,R4
	RCALL _WriteEeprom
; 0000 0068             WriteEeprom((ring_disp-1)*3+2,hour);
	RCALL SUBOPT_0xB
	ADIW R30,2
	RCALL SUBOPT_0x3
	MOV  R26,R5
	RCALL _WriteEeprom
; 0000 0069         }
; 0000 006A     }
_0x1E:
; 0000 006B }
_0x1D:
_0x1C:
	RET
; .FEND
;
;void ring_button() {
; 0000 006D void ring_button() {
_ring_button:
; .FSTART _ring_button
; 0000 006E     // One touch
; 0000 006F     // Reset setup mode
; 0000 0070     set_mode = 0;
	RCALL SUBOPT_0xA
; 0000 0071     ring_disp++; // None 0, Ring 1,2,3,4,5,6,7
	LDS  R30,_ring_disp
	SUBI R30,-LOW(1)
	STS  _ring_disp,R30
; 0000 0072     if (ring_disp > 1) {
	LDS  R26,_ring_disp
	CPI  R26,LOW(0x2)
	BRLO _0x1F
; 0000 0073         // Save ring set
; 0000 0074         WriteEeprom((ring_disp-2)*3,ring_set);
	LDI  R31,0
	SBIW R30,2
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12
	RCALL SUBOPT_0x3
	MOV  R26,R10
	RCALL _WriteEeprom
; 0000 0075     }
; 0000 0076     if (ring_disp > 7) ring_disp = 0;
_0x1F:
	LDS  R26,_ring_disp
	CPI  R26,LOW(0x8)
	BRLO _0x20
	LDI  R30,LOW(0)
	STS  _ring_disp,R30
; 0000 0077     // Read ring settings from eeprom
; 0000 0078     if (ring_disp) {
_0x20:
	RCALL SUBOPT_0x8
	BREQ _0x21
; 0000 0079         // Read from EEPROM
; 0000 007A         ring_set = ReadEeprom((ring_disp-1)*3);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x2
	MOV  R10,R30
; 0000 007B         min = ReadEeprom((ring_disp-1)*3+1);
	RCALL SUBOPT_0xB
	ADIW R30,1
	RCALL SUBOPT_0x2
	MOV  R4,R30
; 0000 007C         hour = ReadEeprom((ring_disp-1)*3+2);
	RCALL SUBOPT_0xB
	ADIW R30,2
	RCALL SUBOPT_0x2
	MOV  R5,R30
; 0000 007D     }
; 0000 007E }
_0x21:
	RET
; .FEND
;
;void display(unsigned int flashing) {
; 0000 0080 void display(unsigned int flashing) {
_display:
; .FSTART _display
; 0000 0081     static char symbol;
; 0000 0082     symbol++;
	RCALL SUBOPT_0x0
;	flashing -> Y+0
	LDS  R30,_symbol_S0000006000
	SUBI R30,-LOW(1)
	STS  _symbol_S0000006000,R30
; 0000 0083     if (symbol > 5) {
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x6)
	BRLO _0x22
; 0000 0084         symbol = 0;
	LDI  R30,LOW(0)
	STS  _symbol_S0000006000,R30
; 0000 0085     }
; 0000 0086     //symbol = 5;
; 0000 0087     // OFF display
; 0000 0088     PORTD &= 0x03;
_0x22:
	IN   R30,0x12
	ANDI R30,LOW(0x3)
	OUT  0x12,R30
; 0000 0089     PORTC &= 0xF0;
	IN   R30,0x15
	ANDI R30,LOW(0xF0)
	OUT  0x15,R30
; 0000 008A     PORTB.7 = 1;
	SBI  0x18,7
; 0000 008B 
; 0000 008C     if (symbol == 0) {
	LDS  R30,_symbol_S0000006000
	CPI  R30,0
	BRNE _0x25
; 0000 008D         PORTC |= (0x0F & (hour / 10));
	IN   R22,21
	MOV  R26,R5
	RCALL SUBOPT_0xD
	RJMP _0x73
; 0000 008E     } else if (symbol == 1) {
_0x25:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1)
	BRNE _0x27
; 0000 008F         PORTC |= (0x0F & (hour % 10));
	IN   R22,21
	MOV  R26,R5
	RJMP _0x74
; 0000 0090     } else if (symbol == 2) {
_0x27:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x2)
	BRNE _0x29
; 0000 0091         PORTC |= (0x0F & (min / 10));
	IN   R22,21
	MOV  R26,R4
	RCALL SUBOPT_0xD
	RJMP _0x73
; 0000 0092     } else if (symbol == 3) {
_0x29:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x3)
	BRNE _0x2B
; 0000 0093         PORTC |= (0x0F & (min % 10));
	IN   R22,21
	MOV  R26,R4
	RJMP _0x74
; 0000 0094     } else if (symbol == 4) {
_0x2B:
	RCALL SUBOPT_0xE
	BRNE _0x2D
; 0000 0095         PORTC |= (0x0F & (sec / 10));
	IN   R22,21
	MOV  R26,R7
	RCALL SUBOPT_0xD
	RJMP _0x73
; 0000 0096     } else if (symbol == 5) {
_0x2D:
	RCALL SUBOPT_0xF
	BRNE _0x2F
; 0000 0097         // Show week in last symbol
; 0000 0098         if (set_mode == WEEK_M) {
	RCALL SUBOPT_0x7
	BRNE _0x30
; 0000 0099             PORTC |= (0x0F & (week % 10));
	IN   R22,21
	MOV  R26,R6
	RJMP _0x74
; 0000 009A         } else if (ring_disp) {
_0x30:
	RCALL SUBOPT_0x8
	BREQ _0x32
; 0000 009B             PORTC |= (0x0F & (ring_disp % 10));
	IN   R22,21
	LDS  R26,_ring_disp
	RJMP _0x74
; 0000 009C         } else {
_0x32:
; 0000 009D             PORTC |= (0x0F & (sec % 10));
	IN   R22,21
	MOV  R26,R7
_0x74:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
_0x73:
	ANDI R30,LOW(0xF)
	OR   R30,R22
	OUT  0x15,R30
; 0000 009E         }
; 0000 009F     }
; 0000 00A0 
; 0000 00A1     if (symbol == 1) {
_0x2F:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1)
	BREQ _0x75
; 0000 00A2         // Point after hours
; 0000 00A3         PORTB.7 = 0;
; 0000 00A4     } else if (symbol == 3 && !ring_disp) {
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x3)
	BRNE _0x39
	RCALL SUBOPT_0x8
	BREQ _0x3A
_0x39:
	RJMP _0x38
_0x3A:
; 0000 00A5         // Point after mins
; 0000 00A6         PORTB.7 = 0;
	RJMP _0x75
; 0000 00A7     } else if (symbol == 5 && ring_set) {
_0x38:
	RCALL SUBOPT_0xF
	BRNE _0x3F
	TST  R10
	BRNE _0x40
_0x3F:
	RJMP _0x3E
_0x40:
; 0000 00A8         // Point after secs
; 0000 00A9         PORTB.7 = 0;
_0x75:
	CBI  0x18,7
; 0000 00AA     }
; 0000 00AB 
; 0000 00AC     if (flashing < 500) {
_0x3E:
	RCALL SUBOPT_0x10
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRSH _0x43
; 0000 00AD         if (symbol >= 0 && symbol <= 1 && set_mode == HOUR_M) {
	RCALL SUBOPT_0xC
	CPI  R26,0
	BRLO _0x45
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x2)
	BRSH _0x45
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x1)
	BREQ _0x46
_0x45:
	RJMP _0x44
_0x46:
; 0000 00AE             // Flashing hour
; 0000 00AF             return;
	RJMP _0x20A0002
; 0000 00B0         } else if (symbol >= 2 && symbol <= 3 && set_mode == MIN_M) {
_0x44:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x2)
	BRLO _0x49
	RCALL SUBOPT_0xE
	BRSH _0x49
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x2)
	BREQ _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 00B1             // Flashing min
; 0000 00B2             return;
	RJMP _0x20A0002
; 0000 00B3         } else if (symbol >= 4 && symbol <= 5 && set_mode == SEC_M) {
_0x48:
	RCALL SUBOPT_0xE
	BRLO _0x4D
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x6)
	BRSH _0x4D
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x3)
	BREQ _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 00B4             // Flashing sec
; 0000 00B5             return;
	RJMP _0x20A0002
; 0000 00B6         } else if (symbol == 5 && set_mode == WEEK_M) {
_0x4C:
	RCALL SUBOPT_0xF
	BRNE _0x51
	RCALL SUBOPT_0x7
	BREQ _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 00B7             // Flashing week
; 0000 00B8             return;
	RJMP _0x20A0002
; 0000 00B9         }
; 0000 00BA     }
_0x50:
; 0000 00BB 
; 0000 00BC     if (set_mode == WEEK_M && symbol < 5) {
_0x43:
	RCALL SUBOPT_0x7
	BRNE _0x54
	RCALL SUBOPT_0xF
	BRLO _0x55
_0x54:
	RJMP _0x53
_0x55:
; 0000 00BD         // Don't show first 5 symbols
; 0000 00BE         return;
	RJMP _0x20A0002
; 0000 00BF     }
; 0000 00C0 
; 0000 00C1     if (ring_disp && symbol > 3 && symbol < 5) {
_0x53:
	RCALL SUBOPT_0x8
	BREQ _0x57
	RCALL SUBOPT_0xE
	BRLO _0x57
	RCALL SUBOPT_0xF
	BRLO _0x58
_0x57:
	RJMP _0x56
_0x58:
; 0000 00C2         // Don't show last 2 symbols
; 0000 00C3         return;
	RJMP _0x20A0002
; 0000 00C4     }
; 0000 00C5 
; 0000 00C6     // Next symbol
; 0000 00C7     PORTD |= (1 << (2 + symbol));
_0x56:
	IN   R1,18
	LDS  R30,_symbol_S0000006000
	SUBI R30,-LOW(2)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	OUT  0x12,R30
; 0000 00C8 }
_0x20A0002:
	ADIW R28,2
	RET
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
; 0000 00CB interrupt [10] void timer0_ovf_isr(void) {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00CC     // Reinitialize Timer 0 value
; 0000 00CD     TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 00CE     // Place your code here
; 0000 00CF     // Read timeout
; 0000 00D0     if (get_time > 0) get_time--;
	LDS  R26,_get_time
	LDS  R27,_get_time+1
	RCALL __CPW02
	BRSH _0x59
	LDI  R26,LOW(_get_time)
	LDI  R27,HIGH(_get_time)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00D1     // One touch
; 0000 00D2     if (PINB.0 != set) {
_0x59:
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	LDS  R30,_set
	RCALL SUBOPT_0x11
	BREQ _0x5A
; 0000 00D3         if (!set) {
	LDS  R30,_set
	CPI  R30,0
	BRNE _0x5B
; 0000 00D4             // Button released
; 0000 00D5             set_button();
	RCALL _set_button
; 0000 00D6         }
; 0000 00D7         set = PINB.0;
_0x5B:
	RCALL SUBOPT_0x12
; 0000 00D8     }
; 0000 00D9     // Long touch
; 0000 00DA     if (PINB.0 == 0) {
_0x5A:
	SBIC 0x16,0
	RJMP _0x5C
; 0000 00DB         bt_set++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 00DC         if (bt_set > 1500) {
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	CP   R30,R12
	CPC  R31,R13
	BRSH _0x5D
; 0000 00DD             bt_set = 1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	MOVW R12,R30
; 0000 00DE             set_button();
	RCALL _set_button
; 0000 00DF         }
; 0000 00E0     } else bt_set = 0;
_0x5D:
	RJMP _0x5E
_0x5C:
	CLR  R12
	CLR  R13
; 0000 00E1     // One touch
; 0000 00E2     if (PINB.1 != mode) {
_0x5E:
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	LDS  R30,_mode
	RCALL SUBOPT_0x11
	BREQ _0x5F
; 0000 00E3         if (!mode) {
	LDS  R30,_mode
	CPI  R30,0
	BRNE _0x60
; 0000 00E4             // Button released
; 0000 00E5             mode_button();
	RCALL _mode_button
; 0000 00E6         }
; 0000 00E7         mode = PINB.1;
_0x60:
	RCALL SUBOPT_0x13
; 0000 00E8     }
; 0000 00E9     // One touch
; 0000 00EA     if (PINB.2 != ring) {
_0x5F:
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	LDS  R30,_ring
	RCALL SUBOPT_0x11
	BREQ _0x61
; 0000 00EB         if (!ring) {
	LDS  R30,_ring
	CPI  R30,0
	BRNE _0x62
; 0000 00EC             // Button released
; 0000 00ED             ring_button();
	RCALL _ring_button
; 0000 00EE         }
; 0000 00EF         ring = PINB.2;
_0x62:
	RCALL SUBOPT_0x14
; 0000 00F0     }
; 0000 00F1     // Flashing 500ms
; 0000 00F2     static unsigned int flashing;
_0x61:
; 0000 00F3     flashing++;
	LDI  R26,LOW(_flashing_S0000007000)
	LDI  R27,HIGH(_flashing_S0000007000)
	RCALL SUBOPT_0x15
; 0000 00F4     if (flashing > 999) flashing = 0;
	RCALL SUBOPT_0x16
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0x63
	LDI  R30,LOW(0)
	STS  _flashing_S0000007000,R30
	STS  _flashing_S0000007000+1,R30
; 0000 00F5 
; 0000 00F6     // Display  4ms - one symbol
; 0000 00F7     static char disp;
_0x63:
; 0000 00F8     disp++;
	LDS  R30,_disp_S0000007000
	SUBI R30,-LOW(1)
	STS  _disp_S0000007000,R30
; 0000 00F9     if (disp > 3) disp = 0;
	LDS  R26,_disp_S0000007000
	CPI  R26,LOW(0x4)
	BRLO _0x64
	LDI  R30,LOW(0)
	STS  _disp_S0000007000,R30
; 0000 00FA     if (disp == 0) display(flashing);
_0x64:
	LDS  R30,_disp_S0000007000
	CPI  R30,0
	BRNE _0x65
	RCALL SUBOPT_0x16
	RCALL _display
; 0000 00FB 
; 0000 00FC     // Back to time screen
; 0000 00FD     static unsigned long back2time;
_0x65:
; 0000 00FE     if (ring_disp || set_mode) {
	RCALL SUBOPT_0x8
	BRNE _0x67
	RCALL SUBOPT_0x4
	CPI  R30,0
	BREQ _0x66
_0x67:
; 0000 00FF         back2time++;
	LDI  R26,LOW(_back2time_S0000007000)
	LDI  R27,HIGH(_back2time_S0000007000)
	RCALL __GETD1P_INC
	__SUBD1N -1
	RCALL __PUTDP1_DEC
; 0000 0100     }
; 0000 0101     if (back2time > 300000) {
_0x66:
	LDS  R26,_back2time_S0000007000
	LDS  R27,_back2time_S0000007000+1
	LDS  R24,_back2time_S0000007000+2
	LDS  R25,_back2time_S0000007000+3
	__CPD2N 0x493E1
	BRLO _0x69
; 0000 0102         set_mode = 0;
	RCALL SUBOPT_0xA
; 0000 0103         ring_disp = 0;
	LDI  R30,LOW(0)
	STS  _ring_disp,R30
; 0000 0104         back2time = 0;
	STS  _back2time_S0000007000,R30
	STS  _back2time_S0000007000+1,R30
	STS  _back2time_S0000007000+2,R30
	STS  _back2time_S0000007000+3,R30
; 0000 0105     }
; 0000 0106 
; 0000 0107 }
_0x69:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 010A {
_main:
; .FSTART _main
; 0000 010B // Declare your local variables here
; 0000 010C 
; 0000 010D // Input/Output Ports initialization
; 0000 010E // Port B initialization
; 0000 010F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0110 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 0111 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=1 Bit0=1
; 0000 0112 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(7)
	OUT  0x18,R30
; 0000 0113 
; 0000 0114 // Port C initialization
; 0000 0115 // Function: Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0116 DDRC=(1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(127)
	OUT  0x14,R30
; 0000 0117 // State: Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0118 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0119 
; 0000 011A // Port D initialization
; 0000 011B // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 011C DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 011D // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 011E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 011F 
; 0000 0120 // Timer/Counter 0 initialization
; 0000 0121 // Clock source: System Clock
; 0000 0122 // Clock value: 125,000 kHz
; 0000 0123 TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0124 TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0125 
; 0000 0126 // Timer/Counter 1 initialization
; 0000 0127 // Clock source: System Clock
; 0000 0128 // Clock value: Timer1 Stopped
; 0000 0129 // Mode: Normal top=0xFFFF
; 0000 012A // OC1A output: Disconnected
; 0000 012B // OC1B output: Disconnected
; 0000 012C // Noise Canceler: Off
; 0000 012D // Input Capture on Falling Edge
; 0000 012E // Timer1 Overflow Interrupt: Off
; 0000 012F // Input Capture Interrupt: Off
; 0000 0130 // Compare A Match Interrupt: Off
; 0000 0131 // Compare B Match Interrupt: Off
; 0000 0132 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0133 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0134 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0135 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0136 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0137 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0138 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0139 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 013A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 013B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 013C 
; 0000 013D // Timer/Counter 2 initialization
; 0000 013E // Clock source: System Clock
; 0000 013F // Clock value: Timer2 Stopped
; 0000 0140 // Mode: Normal top=0xFF
; 0000 0141 // OC2 output: Disconnected
; 0000 0142 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0143 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0144 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0145 OCR2=0x00;
	OUT  0x23,R30
; 0000 0146 
; 0000 0147 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0148 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0149 
; 0000 014A 
; 0000 014B 
; 0000 014C // USART initialization
; 0000 014D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 014E // USART Receiver: Off
; 0000 014F // USART Transmitter: On
; 0000 0150 // USART Mode: Asynchronous
; 0000 0151 // USART Baud Rate: 9600
; 0000 0152 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0153 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0154 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0155 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0156 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0157 
; 0000 0158 // Bit-Banged I2C Bus initialization
; 0000 0159 // I2C Port: PORTC
; 0000 015A // I2C SDA bit: 4
; 0000 015B // I2C SCL bit: 5
; 0000 015C // Bit Rate: 100 kHz
; 0000 015D // Note: I2C settings are specified in the
; 0000 015E // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 015F i2c_init();
	RCALL _i2c_init
; 0000 0160 
; 0000 0161 // DS1307 Real Time Clock initialization
; 0000 0162 // Square wave output on pin SQW/OUT: Off
; 0000 0163 // SQW/OUT pin state: 0
; 0000 0164 rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 0165 
; 0000 0166 set = PINB.0;
	RCALL SUBOPT_0x12
; 0000 0167 mode = PINB.1;
	RCALL SUBOPT_0x13
; 0000 0168 ring = PINB.2;
	RCALL SUBOPT_0x14
; 0000 0169 
; 0000 016A // Global enable interrupts
; 0000 016B #asm("sei")
	sei
; 0000 016C 
; 0000 016D while (1) {
_0x6A:
; 0000 016E       // Place your code here
; 0000 016F       if (get_time == 0) {
	LDS  R30,_get_time
	LDS  R31,_get_time+1
	SBIW R30,0
	BREQ PC+2
	RJMP _0x6D
; 0000 0170             if (!set_mode && !ring_disp) {
	RCALL SUBOPT_0x4
	CPI  R30,0
	BRNE _0x6F
	RCALL SUBOPT_0x8
	BREQ _0x70
_0x6F:
	RJMP _0x6E
_0x70:
; 0000 0171                 rtc_get_time(&hour,&min,&sec);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL _rtc_get_time
; 0000 0172                 rtc_get_date(&week,&day,&mon,&year);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(11)
	LDI  R27,HIGH(11)
	RCALL _rtc_get_date
; 0000 0173                 buzzer();
	RCALL _buzzer
; 0000 0174                 printf("w%d_%d:%d:%d\r",week,hour,min,sec);
	__POINTW1FN _0x0,20
	RCALL SUBOPT_0x3
	MOV  R30,R6
	RCALL SUBOPT_0x5
	MOV  R30,R5
	RCALL SUBOPT_0x5
	MOV  R30,R4
	RCALL SUBOPT_0x5
	MOV  R30,R7
	RCALL SUBOPT_0x5
	LDI  R24,16
	RCALL _printf
	ADIW R28,18
; 0000 0175             } else printf("set_mode:%d: w%d_%d:%d:%d\r",set_mode,week,hour,min,sec);
	RJMP _0x71
_0x6E:
	__POINTW1FN _0x0,34
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	MOV  R30,R6
	RCALL SUBOPT_0x5
	MOV  R30,R5
	RCALL SUBOPT_0x5
	MOV  R30,R4
	RCALL SUBOPT_0x5
	MOV  R30,R7
	RCALL SUBOPT_0x5
	LDI  R24,20
	RCALL _printf
	ADIW R28,22
; 0000 0176             get_time = 100; // 500*1ms = 500ms
_0x71:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _get_time,R30
	STS  _get_time+1,R31
; 0000 0177       }
; 0000 0178       }
_0x6D:
	RJMP _0x6A
; 0000 0179 }
_0x72:
	RJMP _0x72
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	RCALL SUBOPT_0x17
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL SUBOPT_0x18
	RJMP _0x20A0001
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x17
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	RCALL SUBOPT_0x17
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x18
	RJMP _0x20A0001
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x17
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1B
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x10
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	RCALL SUBOPT_0x17
	LDI  R26,LOW(3)
	RCALL _i2c_write
	LDD  R26,Y+3
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x18
	ADIW R28,4
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
; .FEND
_put_usart_G101:
; .FSTART _put_usart_G101
	RCALL SUBOPT_0x0
	LDD  R26,Y+2
	RCALL _putchar
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x15
_0x20A0001:
	ADIW R28,3
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	RCALL SUBOPT_0x0
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x21
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x21
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x22
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x24
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	RCALL SUBOPT_0x27
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	RCALL SUBOPT_0x27
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x28
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x28
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x21
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x27
	RJMP _0x2020054
_0x2020053:
	RCALL SUBOPT_0x20
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x21
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x27
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x24
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x21
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x24
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x3
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G101)
	LDI  R31,HIGH(_put_usart_G101)
	RCALL SUBOPT_0x3
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x0
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x0
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_get_time:
	.BYTE 0x2
_set_mode:
	.BYTE 0x1
_set:
	.BYTE 0x1
_mode:
	.BYTE 0x1
_ring:
	.BYTE 0x1
_ring_disp:
	.BYTE 0x1
_old_min_S0000002000:
	.BYTE 0x1
_symbol_S0000006000:
	.BYTE 0x1
_flashing_S0000007000:
	.BYTE 0x2
_disp_S0000007000:
	.BYTE 0x1
_back2time_S0000007000:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	MOV  R30,R6
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	MOVW R26,R30
	RJMP _ReadEeprom

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDS  R30,_set_mode
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x5:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDS  R26,_set_mode
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x8:
	LDS  R30,_ring_disp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	STS  _set_mode,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	LDS  R30,_ring_disp
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xC:
	LDS  R26,_symbol_S0000006000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x11:
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDI  R30,0
	SBIC 0x16,0
	LDI  R30,1
	STS  _set,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R30,0
	SBIC 0x16,1
	LDI  R30,1
	STS  _mode,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	STS  _ring,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDS  R26,_flashing_S0000007000
	LDS  R27,_flashing_S0000007000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	RCALL _i2c_write
	RJMP _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RCALL _i2c_write
	LDI  R26,LOW(1)
	RJMP _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	ST   X,R30
	LDI  R26,LOW(1)
	RCALL _i2c_read
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	RCALL _i2c_write
	LD   R26,Y
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL _i2c_write
	LDD  R26,Y+1
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x21:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x22
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
	.equ __sda_bit=4
	.equ __scl_bit=5
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
