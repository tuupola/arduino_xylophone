FasdUAS 1.101.10   ��   ��    k             l     ��  ��    = 7 Sample connection attachment script for Serial Bridge.     � 	 	 n   S a m p l e   c o n n e c t i o n   a t t a c h m e n t   s c r i p t   f o r   S e r i a l   B r i d g e .   
  
 l     ��������  ��  ��        l     ��  ��    , & 2005-03-29 Original. (Matt Bendiksen)     �   L   2 0 0 5 - 0 3 - 2 9   O r i g i n a l .   ( M a t t   B e n d i k s e n )      l     ��  ��    < 6 2005-04-01 Fixed event timeout bugs. (Matt Bendiksen)     �   l   2 0 0 5 - 0 4 - 0 1   F i x e d   e v e n t   t i m e o u t   b u g s .   ( M a t t   B e n d i k s e n )      l     ��������  ��  ��        l     ��  ��     	---------     �    - - - - - - - - -      l     ��   ��            � ! !      " # " i      $ % $ I      �� &���� *0 myprocessserialdata MyProcessSerialData &  '�� ' o      ���� 0 arduino  ��  ��   % O    K ( ) ( k   J * *  + , + l   ��������  ��  ��   ,  - . - l   �� / 0��   / > 8 6 bytes is the shortest possible command we can receive    0 � 1 1 p   6   b y t e s   i s   t h e   s h o r t e s t   p o s s i b l e   c o m m a n d   w e   c a n   r e c e i v e .  2 3 2 I   �� 4 5
�� .SRBRWtDtnull���    utf8 4 o    ���� 0 arduino   5 �� 6��
�� 
ByCt 6 m    ���� ��   3  7 8 7 l   �� 9 :��   9  delay 1    : � ; ;  d e l a y   1 8  < = < l   ��������  ��  ��   =  > ? > r     @ A @ I   �� B��
�� .SRBRRdDtutf8       utf8 B o    ���� 0 arduino  ��   A o      ���� 0 incoming   ?  C D C l   �� E F��   E &  log incoming using type "Sample"    F � G G @ l o g   i n c o m i n g   u s i n g   t y p e   " S a m p l e " D  H I H l   ��������  ��  ��   I  J K J l   �� L M��   L - ' Incoming protocol is command:parameter    M � N N N   I n c o m i n g   p r o t o c o l   i s   c o m m a n d : p a r a m e t e r K  O P O r     Q R Q n    S T S 1    ��
�� 
txdl T 1    ��
�� 
ascr R o      ���� 0 previous   P  U V U r     W X W m     Y Y � Z Z  : X n      [ \ [ 1    ��
�� 
txdl \ 1    ��
�� 
ascr V  ] ^ ] r     % _ ` _ n     # a b a 2  ! #��
�� 
citm b o     !���� 0 incoming   ` o      ���� 0 temp   ^  c d c r   & + e f e o   & '���� 0 previous   f n      g h g 1   ( *��
�� 
txdl h 1   ' (��
�� 
ascr d  i j i r   , 2 k l k n   , 0 m n m 4   - 0�� o
�� 
cobj o m   . /����  n o   , -���� 0 temp   l o      ���� 0 command   j  p q p r   3 9 r s r n   3 7 t u t 4   4 7�� v
�� 
cobj v m   5 6����  u o   3 4���� 0 temp   s o      ���� 0 	parameter   q  w x w l  : :��������  ��  ��   x  y z y l  : :�� { |��   {    Remove trailing newline		    | � } } 4   R e m o v e   t r a i l i n g   n e w l i n e 	 	 z  ~  ~ r   : U � � � n   : S � � � 7  ; S�� � �
�� 
ctxt � m   ? A����  � l  B R ����� � \   B R � � � l  C P ����� � I  C P���� �
�� .sysooffslong    ��� null��   � �� � �
�� 
psof � I  E J�� ���
�� .sysontocTEXT       shor � m   E F���� 
��   � �� ���
�� 
psin � o   K L���� 0 	parameter  ��  ��  ��   � m   P Q���� ��  ��   � o   : ;���� 0 	parameter   � o      ���� 0 	parameter     � � � l  V V��������  ��  ��   �  � � � Z   VH � � ��� � =  V [ � � � o   V W���� 0 command   � m   W Z � � � � �  r e c o r d � Q   ^ � � � � � k   a � � �  � � � O   a ~ � � � k   g } � �  � � � I  g l������
�� .miscactvnull��� ��� null��  ��   �  � � � I  m r������
�� .MVWRnavrnull��� ��� null��  ��   �  ��� � I  s }�� ���
�� .MVWRstarnull���     docu � 4  s y�� �
�� 
docu � m   w x���� ��  ��   � m   a d � ��                                                                                  mgvr  alis    t  Macintosh HD               ƫ�&H+     rQuickTime Player.app                                             ���:Z�        ����  	                Applications    ƫ{�      �:0P       r  .Macintosh HD:Applications:QuickTime Player.app  *  Q u i c k T i m e   P l a y e r . a p p    M a c i n t o s h   H D  !Applications/QuickTime Player.app   / ��   �  ��� � I   ��� � �
�� .SRBRLog null���    utf8 � m    � � � � � �  S t a r t   r e c o r d i n g � �� ���
�� 
LgTy � m   � � � � � � �  C o m m a n d��  ��   � R      ������
�� .ascrerr ****      � ****��  ��   � I  � ��� � �
�� .SRBRLog null���    utf8 � m   � � � � � � � , S t a r t   r e c o r d i n g   f a i l e d � �� ���
�� 
LgTy � m   � � � � � � �  C o m m a n d��   �  � � � =  � � � � � o   � ����� 0 command   � m   � � � � � � �  s t o p �  � � � k   �. � �  � � � Q   �  � � � � k   � � �  � � � O   �	 � � � k   � � �  � � � I  � ��� ���
�� .MVWRstopnull���     docu � 4  � ��� �
�� 
docu � m   � ����� ��   �  � � � r   � � � � � c   � � � � � n   � � � � � m   � ���
�� 
file � 4  � ��� �
�� 
docu � m   � �����  � m   � ���
�� 
alis � o      ���� 0 
video_file   �  � � � I  � ��� ���
�� .coreclosnull���     obj  � 4  � ��� �
�� 
docu � m   � ����� ��   �  � � � O   � � � � k   � � �  � � � r   � � � � � o   � ����� 0 	parameter   � n       � � � 1   � ���
�� 
pnam � o   � ����� 0 
video_file   �  ��� � I  ��� � �
�� .coremoveobj        obj  � o   � ����� 0 
video_file   � �� � �
�� 
insh � n   � � � � � 4   � ��� �
�� 
cfol � m   � � � � � � � 4 U s e r s : t u u p o l a : M o v i e s : r s y n c � 4   � ��� �
�� 
cdis � m   � � � � � � �  M a c i n t o s h   H D � � ��~
� 
alrp � m   �}
�} boovtrue�~  ��   � m   � � � ��                                                                                  MACS  alis    r  Macintosh HD               ƫ�&H+     j
Finder.app                                                       ��Ƙv        ����  	                CoreServices    ƫ{�      ƘK�       j   '   &  3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��   �  � � � l �| � ��|   �  say "Stop recording."    � � � � * s a y   " S t o p   r e c o r d i n g . " �  ��{ � l �z�y�x�z  �y  �x  �{   � m   � � � ��                                                                                  mgvr  alis    t  Macintosh HD               ƫ�&H+     rQuickTime Player.app                                             ���:Z�        ����  	                Applications    ƫ{�      �:0P       r  .Macintosh HD:Applications:QuickTime Player.app  *  Q u i c k T i m e   P l a y e r . a p p    M a c i n t o s h   H D  !Applications/QuickTime Player.app   / ��   �    l 

�w�w     QuickTime Player    � "   Q u i c k T i m e   P l a y e r �v l 

�u�t�s�u  �t  �s  �v   � R      �r�q�p
�r .ascrerr ****      � ****�q  �p   � I  �o
�o .SRBRLog null���    utf8 m   �		 * S t o p   r e c o r d i n g   f a i l e d �n
�m
�n 
LgTy
 m   � 
 E r r o r�m   �  l !!�l�l   !  Notify Arduino we are done    � 6   N o t i f y   A r d u i n o   w e   a r e   d o n e  I !,�k
�k .SRBRSdDtnull���    utf8 o  !"�j�j 0 arduino   �i�h
�i 
SnDa m  %( �  c�h   �g l --�f�e�d�f  �e  �d  �g   �  = 16 o  12�c�c 0 command   m  25 � 
 d e b u g  �b  I 9D�a!"
�a .SRBRLog null���    utf8! o  9:�`�` 0 	parameter  " �_#�^
�_ 
LgTy# m  =@$$ �%% 
 D e b u g�^  �b  ��   � &�]& l II�\�[�Z�\  �[  �Z  �]   ) m     ''�                                                                                  SRBR  alis    h  Macintosh HD               ƫ�&H+     rSerial Bridge.app                                               �t�rA�        ����  	                Applications    ƫ{�      �r�       r  +Macintosh HD:Applications:Serial Bridge.app   $  S e r i a l   B r i d g e . a p p    M a c i n t o s h   H D  Applications/Serial Bridge.app  / ��   # ()( l     �Y�X�W�Y  �X  �W  ) *+* l     �V,-�V  ,  	---------   - �..  - - - - - - - - -+ /0/ l     �U12�U  1 V P Serial Bridge will call the startCommunication() subroutine after it has opened   2 �33 �   S e r i a l   B r i d g e   w i l l   c a l l   t h e   s t a r t C o m m u n i c a t i o n ( )   s u b r o u t i n e   a f t e r   i t   h a s   o p e n e d0 454 l     �T67�T  6 Y S the serial port connection for this connection. It is only called after the serial   7 �88 �   t h e   s e r i a l   p o r t   c o n n e c t i o n   f o r   t h i s   c o n n e c t i o n .   I t   i s   o n l y   c a l l e d   a f t e r   t h e   s e r i a l5 9:9 l     �S;<�S  ; R L port connection has been opened, shortly after Serial Bridge launches or if   < �== �   p o r t   c o n n e c t i o n   h a s   b e e n   o p e n e d ,   s h o r t l y   a f t e r   S e r i a l   B r i d g e   l a u n c h e s   o r   i f: >?> l     �R@A�R  @ 1 + the user presses the Reload Script button.   A �BB V   t h e   u s e r   p r e s s e s   t h e   R e l o a d   S c r i p t   b u t t o n .? CDC l     �Q�P�O�Q  �P  �O  D EFE i    GHG I      �NI�M�N (0 startcommunication startCommunicationI J�LJ o      �K�K  0 connectionname connectionName�L  �M  H O     qKLK k    pMM NON l   �J�I�H�J  �I  �H  O PQP l   �GRS�G  R L F Loop forever: wait for data, read it, process it, and optionally send   S �TT �   L o o p   f o r e v e r :   w a i t   f o r   d a t a ,   r e a d   i t ,   p r o c e s s   i t ,   a n d   o p t i o n a l l y   s e n dQ UVU l   �FWX�F  W   out serial data.   X �YY "   o u t   s e r i a l   d a t a .V Z�EZ V    p[\[ Q   
 k]^_] k    `` aba l   cdec r    fgf m    �D�D  ���g o      �C�C "0 maxtimeoutdelay maxTimeoutDelayd #  103.56 days (hex 0x00888888)   e �hh :   1 0 3 . 5 6   d a y s   ( h e x   0 x 0 0 8 8 8 8 8 8 )b i�Bi t    jkj n   lml I    �An�@�A *0 myprocessserialdata MyProcessSerialDatan o�?o o    �>�>  0 connectionname connectionName�?  �@  m  f    k o    �=�= "0 maxtimeoutdelay maxTimeoutDelay�B  ^ R      �<�;p
�< .ascrerr ****      � ****�;  p �:q�9
�: 
errnq o      �8�8 0 errnum errNum�9  _ k   " krr sts l   " "�7uv�7  u� Log timeout errors (-1712) but continue processing loop. Without
				 * handling this error, the script would throw out of the repeat loop
				 * and terminate if any of the script calls were to throw a timeout error.
				 * Normally, if there was a timeout error thrown you would want
				 * to continue processing your main loop in an attempt to get back
				 * in syncronization with the hardware. By catching this error we
				 * will do exactly this and continue to process our script repeat loop.
				    v �ww�   L o g   t i m e o u t   e r r o r s   ( - 1 7 1 2 )   b u t   c o n t i n u e   p r o c e s s i n g   l o o p .   W i t h o u t 
 	 	 	 	   *   h a n d l i n g   t h i s   e r r o r ,   t h e   s c r i p t   w o u l d   t h r o w   o u t   o f   t h e   r e p e a t   l o o p 
 	 	 	 	   *   a n d   t e r m i n a t e   i f   a n y   o f   t h e   s c r i p t   c a l l s   w e r e   t o   t h r o w   a   t i m e o u t   e r r o r . 
 	 	 	 	   *   N o r m a l l y ,   i f   t h e r e   w a s   a   t i m e o u t   e r r o r   t h r o w n   y o u   w o u l d   w a n t 
 	 	 	 	   *   t o   c o n t i n u e   p r o c e s s i n g   y o u r   m a i n   l o o p   i n   a n   a t t e m p t   t o   g e t   b a c k 
 	 	 	 	   *   i n   s y n c r o n i z a t i o n   w i t h   t h e   h a r d w a r e .   B y   c a t c h i n g   t h i s   e r r o r   w e 
 	 	 	 	   *   w i l l   d o   e x a c t l y   t h i s   a n d   c o n t i n u e   t o   p r o c e s s   o u r   s c r i p t   r e p e a t   l o o p . 
 	 	 	 	  t x�6x Z   " kyz{|y =  " %}~} o   " #�5�5 0 errnum errNum~ m   # $�4�4�Pz I  ( /�3�
�3 .SRBRLog null���    utf8 m   ( )�� ��� > t i m e o u t   w a i t i n g   f o r   s e r i a l   d a t a� �2��1
�2 
LgTy� m   * +�� ��� 
 E r r o r�1  { ��� =  2 5��� o   2 3�0�0 0 errnum errNum� m   3 4�/�/�T� ��� k   8 B�� ��� I  8 ?�.��
�. .SRBRLog null���    utf8� m   8 9�� ��� , A p p l e E v e n t   n o t   h a n d l e d� �-��,
�- 
LgTy� m   : ;�� ��� 
 E r r o r�,  � ��+� l  @ B���� L   @ B�*�*  � * $ fatal error; exit script processing   � ��� H   f a t a l   e r r o r ;   e x i t   s c r i p t   p r o c e s s i n g�+  � ��� =  E H��� o   E F�)�) 0 errnum errNum� m   F G�(�(��� ��'� k   K U�� ��� I  K R�&��
�& .SRBRLog null���    utf8� m   K L�� ��� 2 c o n n e c t i o n   s c r i p t   a b o r t e d� �%��$
�% 
LgTy� m   M N�� ��� 
 E r r o r�$  � ��#� l  S U���� L   S U�"�"  � * $ fatal error; exit script processing   � ��� H   f a t a l   e r r o r ;   e x i t   s c r i p t   p r o c e s s i n g�#  �'  | k   X k�� ��� I  X i�!��
�! .SRBRLog null���    utf8� b   X a��� b   X ]��� m   X [�� ���  e r r o r  � o   [ \� �  0 errnum errNum� m   ] `�� ��� :   i n s i d e   M y P r o c e s s S e r i a l D a t a ( )� ���
� 
LgTy� m   b e�� ��� 
 E r r o r�  � ��� l  j j����  � 9 3return -- maybe fatal error; exit script processing   � ��� f r e t u r n   - -   m a y b e   f a t a l   e r r o r ;   e x i t   s c r i p t   p r o c e s s i n g�  �6  \ m    	�
� boovtrue�E  L m     ���                                                                                  SRBR  alis    h  Macintosh HD               ƫ�&H+     rSerial Bridge.app                                               �t�rA�        ����  	                Applications    ƫ{�      �r�       r  +Macintosh HD:Applications:Serial Bridge.app   $  S e r i a l   B r i d g e . a p p    M a c i n t o s h   H D  Applications/Serial Bridge.app  / ��  F ��� l     ����  �  �  � ��� l     ����  �  �  �       �����  � ��� *0 myprocessserialdata MyProcessSerialData� (0 startcommunication startCommunication� � %������ *0 myprocessserialdata MyProcessSerialData� ��� �  �� 0 arduino  �  � �
�	������
 0 arduino  �	 0 incoming  � 0 previous  � 0 temp  � 0 command  � 0 	parameter  � 0 
video_file  � 4'���� ���� Y������������������ � ��������� ��� ������� � � ��������� ������� ��� ���������$
� 
ByCt� 
� .SRBRWtDtnull���    utf8
�  .SRBRRdDtutf8       utf8
�� 
ascr
�� 
txdl
�� 
citm
�� 
cobj
�� 
ctxt
�� 
psof�� 

�� .sysontocTEXT       shor
�� 
psin�� 
�� .sysooffslong    ��� null
�� .miscactvnull��� ��� null
�� .MVWRnavrnull��� ��� null
�� 
docu
�� .MVWRstarnull���     docu
�� 
LgTy
�� .SRBRLog null���    utf8��  ��  
�� .MVWRstopnull���     docu
�� 
file
�� 
alis
�� .coreclosnull���     obj 
�� 
pnam
�� 
insh
�� 
cdis
�� 
cfol
�� 
alrp
�� .coremoveobj        obj 
�� 
SnDa
�� .SRBRSdDtnull���    utf8�L�H���l O�j E�O��,E�O���,FO��-E�O���,FO��k/E�O��l/E�O�[�\[Zk\Z*��j �� l2E�O�a   H 0a  *j O*j O*a k/j UOa a a l W X  a a a l Y ��a   � aa  U*a k/j  O*a k/a !,a "&E�O*a k/j #Oa $ %��a %,FO�a &*a 'a (/a )a */a +e� ,UOPUOPW X  a -a a .l O�a /a 0l 1OPY �a 2  �a a 3l Y hOPU� ��H���������� (0 startcommunication startCommunication�� ����� �  ����  0 connectionname connectionName��  � ��������  0 connectionname connectionName�� "0 maxtimeoutdelay maxTimeoutDelay�� 0 errnum errNum� �����������������������������  ����� *0 myprocessserialdata MyProcessSerialData��  � ������
�� 
errn�� 0 errnum errNum��  ���P
�� 
LgTy
�� .SRBRLog null���    utf8���T������ r� n khe �E�O�n)�k+ oW PX  ��  ���l 	Y ;��  ���l 	OhY (��  ���l 	OhY a �%a %�a l 	OP[OY��Uascr  ��ޭ