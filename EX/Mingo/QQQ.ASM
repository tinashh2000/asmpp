code_seg  SEGMENT
;          ASSUME    CS:code_seg, DS:code_seg
          org       100h

START:    jmp       boot

; =====================================================================

old_08h   DD    ?            ; �०��� ����� ���뢠���: 08h
old_09h   DD    ?            ;                             09h
old_2Fh   DD    ?            ;                             2Fh
video     DW    0B800h       ; ���� (ᥣ����) ��砫� ����������
simbol    DB    7            ; �뢮���� ᨬ���
status    DB    0            ; ���ﭨ� ��᪮����: 0 - ࠧ�����஢��
; =====================================================================

; ---------------------------------------------------------------------
; ��ࠡ��稪 ���뢠��� 2Fh
; ---------------------------------------------------------------------
new_2Fh   PROC

          cmp       AH,        0CCh    ; �஢�ઠ �����
          jne       pass_2Fh           ; �� ��� ����� -> ��室
          cmp       AL,        0       ; �㭪�� �஢�ન �� ��⠭����?
          jne       check2             ; ��� -> �஢��塞 �㭪�� ���㧪�
          mov       AL,        0FFh    ; �ணࠬ�� 㦥 ��⠭������
          iret
check2:   cmp       AL,        1       ; �㭪�� ���㧪� �ணࠬ�� ?
          je        uninstall          ; �� -> �஡㥬 ���㧨��

pass_2Fh: jmp DWORD CS:[old_2Fh]

          ;---------------------------------------------------
          ; �஢�ઠ, �������� �� ���㧪� �ணࠬ�� �� �����
uninstall:
          push      BX
          push      CX
          push      DX
          push      ES
          mov       CX,        CS      ; �㦭� ��� �ࠢ�����

          mov       AX,        3508h   ; �஢�ઠ ����� 08h
          int       21h                ;
          mov       DX,        ES
          cmp       CX,        DX
          jne       not_unins
          cmp       BX,        offset new_08h
          jne       not_unins

          mov       AL,        09h     ; �஢�ઠ ����� 09h
          int       21h                ;
          mov       DX,        ES
          cmp       CX,        DX
          jne       not_unins
          cmp       BX,        offset new_09h
          jne       not_unins

          mov       AL,        2Fh     ; �஢�ઠ ����� 2Fh
          int       21h                ;
          mov       DX,        ES
          cmp       CX,        DX
          jne       not_unins
          cmp       BX,        offset new_2Fh
          jne       not_unins

          ;---------------------------------------------------------------
          ; ����� ���뢠��� �� ���������� -> ����� ���㦠��  �ணࠬ��
          push      DS
          lds       DX,        CS:old_08h     ; DS:DX = �०��� ����� 08h
          mov       AX,        2508h          ; ����⠭�������� ����� 08h
          int       21h
          lds       DX,        CS:old_09h     ; DS:DX = �०��� ����� 09h
          mov       AL,        09h            ; ����⠭�������� ����� 09h
          int       21h
          lds       DX,        CS:old_2Fh     ; DS:DX = �०��� ����� 2Fh
          mov       AL,        2Fh            ; ����⠭�������� ����� 2Fh
          int       21h
          pop       DS

          mov       ES,        CS:2Ch         ; ES -> ���㦥���
          mov       AH,        49h            ; �᢮�������� ����� �����
          int       21h
          mov       ES,        CX             ; ES = CS -> PSP
          mov       AH,        49h            ; �᢮�������� �����, ����⮩
          int       21h                       ; ᠬ�� �ணࠬ���

          xor       AL,        AL             ; �ਧ��� �ᯥ譮� ���㧪�
          jmp short pop_ret

not_unins: mov      AL,        0Fh            ; �ਧ��� ���ᯥ譮� ���㧪�
pop_ret:  pop       ES
          pop       DX
          pop       CX
          pop       BX
          iret

new_2Fh   ENDP

; ---------------------------------------------------------------------
; ��ࠡ��稪 ���뢠��� 08h
; ---------------------------------------------------------------------
new_08h   PROC

          pushf
          call DWORD CS:[old_08h]         ; ᭠砫� ��ࠡ��뢠���� ���
          ; �뢮��� ᨬ��� �� ��࠭ - �������� ࠡ��� �ணࠬ��
          push      AX
          push      ES
          mov       AX,        CS:video    ; ����ᨬ � ES ���� ��砫�
          mov       ES,        AX          ;   ����������
          mov       AL,        CS:simbol   ; �뢮��� ᨬ��� � ��砫�
          mov       ES:[0],    AL          ;   ��ࢮ� ��ப� ��࠭�
          mov BYTE ES:[1],    1Fh         ; ᨭ�� 䮭, ���� ᨬ���
          test      CS:status, 40h         ; ��᪮��� �����஢��?
          jz        nextsim                ; ��� -> ���室 �� nextsim
          xor BYTE ES:[1],    52h         ; ���� 䮭, ஧��� ᨬ���
nextsim:  dec       CS:simbol
          and       CS:simbol, 07h         ; simbol = 7 .. 0
          pop       ES
          pop       AX
          iret

new_08h   ENDP

; ---------------------------------------------------------------------
; ��ࠡ��稪 ���뢠��� 09h
; ---------------------------------------------------------------------
new_09h   PROC

          ; �஢�ઠ ����⮩ �������樨 ������
          push      AX
          in        AL,        60h
          cmp       AL,        14h         ; ����� ������ 'T' ?
          jne       pass_09h               ; ��� -> ��뢠�� ���� ��ࠡ��稪
          push      ES
          mov       AX,        40h         ; �����㥬 � AL 䫠�� ����������
          mov       ES,        AX          ;
          mov       AL,        ES:[17h]    ;
          pop       ES
          and       AL,        00001100b   ; �஢�ઠ, ������ �� Alt �
          cmp       AL,        00001100b   ;   Ctrl
          je        do_pop                 ; ������ -> ����� �㦭�� �����-
                                           ;   ���� Ctrl + Alt + 'T'
pass_09h: pop       AX
          jmp DWORD CS:[old_09h]

do_pop:   ; ����� �㦭�� ��������� ������
          ; ࠧ�襭�� ࠡ��� ����������
          in        AL,        61h
          or        AL,        80h    ; ��⠭����� ���訩 ���
          out       61h,       AL
          and       AL,        7Fh    ; ����� ���訩 ���
          out       61h,       AL
          mov       AL,        20h    ; ࠧ�襭�� ���뢠���
          out       20h,       AL

          ; ॠ��� �ணࠬ�� �� ����⨥ ������
          xor       CS:status, 40h        ; �������� ���ﭨ� ��᪮����
          in        AL,        21h        ; �⥭�� ॣ���� ��᪨
          and       AL,        0BFh       ; ����� ��� 6
          or        AL,        CS:status  ; ��⠭����� ��� 6 , ��� � � status
          out       21h,       AL         ; ��⠭����� ���ﭨ� ��᪮����
          mov       AX,        0E07h       ; ���� ��㪮��� ᨣ���
          int       10h                    ;
          pop       AX
          iret

new_09h   ENDP


; =====================================================================
; ���樠������
; =====================================================================
boot:     ; �஢�ઠ, ��⠭������ �� 㦥 �ணࠬ��
          mov       AX,        0CC00h
          int       2Fh
          mov       insflag,   AL

          ; �஢�ઠ ��������� ��ப�
          mov       CL,        ES:80h     ; �஢�ઠ, �뫨 �� ������
          cmp       CL,        0          ;  ��ࠬ���� �� ����᪥
          je        check_ins             ; ��� -> �஡㥬 ��⠭�����
          xor       CH,        CH         ; CX = ����� ��ப� ��ࠬ��஢
          cld                             ; 䫠� ���ࠢ����� DF = 0 (���।)
          mov       DI,        81h       ; �ய�� ��� �஡���� � ��砫�
          mov       AL,        ' '       ; ��ப� ��ࠬ��஢ (ES:DI)
          repe scasb                     ;
          dec       DI
          mov       CX,        2          ; ��������� ����� �������
          mov       SI,        offset key ; ��������� ������� ���㧪�
          repe cmpsb
          jne       check_ins             ; ����ୠ� �������, �஡㥬
                                          ; ��⠭����� �ணࠬ��

          ; ������� ������� ���㧪� TSR
          cmp       insflag,   0FFh       ; �ணࠬ�� ��⠭������ ?
          je        uninst                ; �� -> �஡㥬 ���㧨��
          lea       DX,        msg4       ; �ணࠬ�� �� ��⠭������, �
out_quit: mov       AH,        09h        ;  � ���짮��⥫� ��� ���㧨��
          int       21h                   ;   ��. �뤠���� ᮮ�. ᮮ�饭��.
          int       20h                   ; ��室 ��� ��⠭����

          ; �஡㥬 ���㧨�� �ணࠬ��
uninst:   mov       AX,        0CC01h     ; �㭪�� ���㧪�
          int       2Fh
          cmp       AL,        0          ; �ணࠬ�� ���㦥�� ?
          je        success               ; �� -> �� ���� success
          lea       DX,        msg3       ; ��� -> �뢮��� ᮮ�. ᮮ�饭��
          jmp       out_quit

success:  lea       DX,        msg5       ; �ணࠬ�� �뫠 ���㦥��
          jmp       out_quit

          ; ��⠭���� �ணࠬ��
check_ins: cmp      insflag,   0FFh       ; �ணࠬ�� ��⠭������ ?
          jne       install               ; ��� -> ��⠭��������
          lea       DX,        msg2       ; �ணࠬ�� 㦥 ��⠭������
          jmp       out_quit

install:  mov       AH,        0Fh        ; ������� ⥪�騩 �����०��
          int       10h                   ;
          cmp       AL,        7          ; ०�� �����஬�� ?
          jne       setvec                ; ��� -> ��⠭�������� �����
          mov       video,     0B000h     ; �����塞 ���� ��砫� ����������

          ; ��⠭���� ��ࠡ��稪� int 2Fh
setvec:   mov       AX,        352Fh           ; ������� �����
          int       21h                        ;  ���뢠��� 2Fh
          mov       WORD [old_2Fh],   BX         ; ��࠭���� ����祭����
          mov       WORD [old_2Fh+2], ES         ;  �����
          mov       DX,        offset new_2Fh  ; ��⠭���� ������ �����
          mov       AX,        252Fh           ;
          int       21h                        ;

          ; ��⠭���� ��ࠡ��稪� int 08h
          mov       AX,        3508h           ; ������� �����
          int       21h                        ;  ���뢠��� 08h
          mov       WORD [old_08h],   BX         ; ��࠭���� ����祭����
          mov       WORD [old_08h+2], ES         ;  �����
          mov       DX,        offset new_08h
          mov       AX,        2508h
          int       21h

          ; ��⠭���� ��ࠡ��稪� int 09h
          mov       AX,        3509h           ; ������� �����
          int       21h                        ;  ���뢠��� 09h
          mov       WORD [old_09h],   BX         ; ��࠭���� ����祭����
          mov       WORD [old_09h+2], ES         ;  �����
          mov       DX,        offset new_09h
          mov       AX,        2509h
          int       21h

          lea       DX,        msg1
          mov       AH,        09h
          int       21h
          mov       DX,        offset boot
          int       27h               ; ��⠢��� �ண. १����⭮� � ���

; ---------------------------------------------------------------------------
msg1      DB    "�ணࠬ�� ���⠫��஢���.",10,13
          DB    "��� �����஢��/ࠧ�����஢�� ��᪮���� ������ Ctrl+Alt+'T'.",10,13
          DB    "�᫨ �������� � ��ࢮ� ��ப� ��࠭� ����, � ��᪮��� �����஢��.",10,13,'$'
msg2      DB    "�ணࠬ�� 㦥 ���⠫��஢���!",10,13,'$'
msg3      DB    "���㧪� ����������!",10,13,'$'
msg4      DB    "�� �� ��⠭������!",10,13,'$'
msg5      DB    "�ணࠬ�� ���㦥��.",10,13,'$'
key       DB    '\u'
insflag   DB    ?
; ---------------------------------------------------------------------------

code_seg  ENDS
          END       START
