FasdUAS 1.101.10   ��   ��    k             l     ��  ��    = 7 Sample connection attachment script for Serial Bridge.     � 	 	 n   S a m p l e   c o n n e c t i o n   a t t a c h m e n t   s c r i p t   f o r   S e r i a l   B r i d g e .   
  
 l     ��������  ��  ��        l     ��  ��    V P This script, if it is in the same folder as the Serial Bridge database settings     �   �   T h i s   s c r i p t ,   i f   i t   i s   i n   t h e   s a m e   f o l d e r   a s   t h e   S e r i a l   B r i d g e   d a t a b a s e   s e t t i n g s      l     ��  ��    U O file (it is by default), will automatically be loaded and launched when Serial     �   �   f i l e   ( i t   i s   b y   d e f a u l t ) ,   w i l l   a u t o m a t i c a l l y   b e   l o a d e d   a n d   l a u n c h e d   w h e n   S e r i a l      l     ��  ��    Q K Bridge is launched. It will be terminated and reloaded whenever any serial     �   �   B r i d g e   i s   l a u n c h e d .   I t   w i l l   b e   t e r m i n a t e d   a n d   r e l o a d e d   w h e n e v e r   a n y   s e r i a l      l     ��  ��    T N port settings change for this connection, or if the Reload button is pressed.     �   �   p o r t   s e t t i n g s   c h a n g e   f o r   t h i s   c o n n e c t i o n ,   o r   i f   t h e   R e l o a d   b u t t o n   i s   p r e s s e d .     !   l     ��������  ��  ��   !  " # " l     �� $ %��   $ I C MyProcessSerialData() below contains sample code you can modify to    % � & & �   M y P r o c e s s S e r i a l D a t a ( )   b e l o w   c o n t a i n s   s a m p l e   c o d e   y o u   c a n   m o d i f y   t o #  ' ( ' l     �� ) *��   ) T N wait for serial data, read serial data, send serial data, and log information    * � + + �   w a i t   f o r   s e r i a l   d a t a ,   r e a d   s e r i a l   d a t a ,   s e n d   s e r i a l   d a t a ,   a n d   l o g   i n f o r m a t i o n (  , - , l     �� . /��   . ' ! to the Serial Bridge log window.    / � 0 0 B   t o   t h e   S e r i a l   B r i d g e   l o g   w i n d o w . -  1 2 1 l     ��������  ��  ��   2  3 4 3 l     �� 5 6��   5 G A The entry point into this file is startCommunication(). Although    6 � 7 7 �   T h e   e n t r y   p o i n t   i n t o   t h i s   f i l e   i s   s t a r t C o m m u n i c a t i o n ( ) .   A l t h o u g h 4  8 9 8 l     �� : ;��   : L F documentation is provided below for both functions; you will probably    ; � < < �   d o c u m e n t a t i o n   i s   p r o v i d e d   b e l o w   f o r   b o t h   f u n c t i o n s ;   y o u   w i l l   p r o b a b l y 9  = > = l     �� ? @��   ? 1 + only need to modify MyProcessSerialData().    @ � A A V   o n l y   n e e d   t o   m o d i f y   M y P r o c e s s S e r i a l D a t a ( ) . >  B C B l     ��������  ��  ��   C  D E D l     �� F G��   F , & 2005-03-29 Original. (Matt Bendiksen)    G � H H L   2 0 0 5 - 0 3 - 2 9   O r i g i n a l .   ( M a t t   B e n d i k s e n ) E  I J I l     �� K L��   K < 6 2005-04-01 Fixed event timeout bugs. (Matt Bendiksen)    L � M M l   2 0 0 5 - 0 4 - 0 1   F i x e d   e v e n t   t i m e o u t   b u g s .   ( M a t t   B e n d i k s e n ) J  N O N l     ��������  ��  ��   O  P Q P l     �� R S��   R  	---------    S � T T  - - - - - - - - - Q  U V U l     �� W X��   W       X � Y Y    V  Z [ Z i      \ ] \ I      �� ^���� *0 myprocessserialdata MyProcessSerialData ^  _�� _ o      ���� 0 arduino  ��  ��   ] O    K ` a ` k   J b b  c d c l   ��������  ��  ��   d  e f e l   �� g h��   g > 8 6 bytes is the shortest possible command we can receive    h � i i p   6   b y t e s   i s   t h e   s h o r t e s t   p o s s i b l e   c o m m a n d   w e   c a n   r e c e i v e f  j k j I   �� l m
�� .SRBRWtDtnull���    utf8 l o    ���� 0 arduino   m �� n��
�� 
ByCt n m    ���� ��   k  o p o l   �� q r��   q  delay 1    r � s s  d e l a y   1 p  t u t l   ��������  ��  ��   u  v w v r     x y x I   �� z��
�� .SRBRRdDtutf8       utf8 z o    ���� 0 arduino  ��   y o      ���� 0 incoming   w  { | { l   �� } ~��   } &  log incoming using type "Sample"    ~ �   @ l o g   i n c o m i n g   u s i n g   t y p e   " S a m p l e " |  � � � l   ��������  ��  ��   �  � � � l   �� � ���   � - ' Incoming protocol is command:parameter    � � � � N   I n c o m i n g   p r o t o c o l   i s   c o m m a n d : p a r a m e t e r �  � � � r     � � � n    � � � 1    ��
�� 
txdl � 1    ��
�� 
ascr � o      ���� 0 previous   �  � � � r     � � � m     � � � � �  : � n      � � � 1    ��
�� 
txdl � 1    ��
�� 
ascr �  � � � r     % � � � n     # � � � 2  ! #��
�� 
citm � o     !���� 0 incoming   � o      ���� 0 temp   �  � � � r   & + � � � o   & '���� 0 previous   � n      � � � 1   ( *��
�� 
txdl � 1   ' (��
�� 
ascr �  � � � r   , 2 � � � n   , 0 � � � 4   - 0�� �
�� 
cobj � m   . /����  � o   , -���� 0 temp   � o      ���� 0 command   �  � � � r   3 9 � � � n   3 7 � � � 4   4 7�� �
�� 
cobj � m   5 6����  � o   3 4���� 0 temp   � o      ���� 0 	parameter   �  � � � l  : :��������  ��  ��   �  � � � l  : :�� � ���   �    Remove trailing newline		    � � � � 4   R e m o v e   t r a i l i n g   n e w l i n e 	 	 �  � � � r   : U � � � n   : S � � � 7  ; S�� � �
�� 
ctxt � m   ? A����  � l  B R ����� � \   B R � � � l  C P ����� � I  C P���� �
�� .sysooffslong    ��� null��   � �� � �
�� 
psof � I  E J�� ���
�� .sysontocTEXT       shor � m   E F���� 
��   � �� ���
�� 
psin � o   K L���� 0 	parameter  ��  ��  ��   � m   P Q���� ��  ��   � o   : ;���� 0 	parameter   � o      ���� 0 	parameter   �  � � � l  V V��������  ��  ��   �  � � � Z   VH � � ��� � =  V [ � � � o   V W���� 0 command   � m   W Z � � � � �  r e c o r d � Q   ^ � � � � � k   a � � �  � � � O   a ~ � � � k   g } � �  � � � I  g l������
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
LgTy � m   � � � � � � �  C o m m a n d��   �  � � � =  � � � � � o   � ����� 0 command   � m   � � � � � � �  s t o p �  � � � k   �. � �  � � � Q   �  � � � � k   �    O   �	 k   �  I  � �����
�� .MVWRstopnull���     docu 4  � ���	
�� 
docu	 m   � ��� ��   

 r   � � c   � � n   � � m   � ��~
�~ 
file 4  � ��}
�} 
docu m   � ��|�|  m   � ��{
�{ 
alis o      �z�z 0 
video_file    I  � ��y�x
�y .coreclosnull���     obj  4  � ��w
�w 
docu m   � ��v�v �x    O   � k   �  r   � � o   � ��u�u 0 	parameter   n       !  1   � ��t
�t 
pnam! o   � ��s�s 0 
video_file   "�r" I  ��q#$
�q .coremoveobj        obj # o   � ��p�p 0 
video_file  $ �o%&
�o 
insh% n   � �'(' 4   � ��n)
�n 
cfol) m   � �** �++ 4 U s e r s : t u u p o l a : M o v i e s : r s y n c( 4   � ��m,
�m 
cdis, m   � �-- �..  M a c i n t o s h   H D& �l/�k
�l 
alrp/ m   �j
�j boovtrue�k  �r   m   � �00�                                                                                  MACS  alis    r  Macintosh HD               ƫ�&H+     j
Finder.app                                                       ��Ƙv        ����  	                CoreServices    ƫ{�      ƘK�       j   '   &  3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��   121 l �i34�i  3  say "Stop recording."   4 �55 * s a y   " S t o p   r e c o r d i n g . "2 6�h6 l �g�f�e�g  �f  �e  �h   m   � �77�                                                                                  mgvr  alis    t  Macintosh HD               ƫ�&H+     rQuickTime Player.app                                             ���:Z�        ����  	                Applications    ƫ{�      �:0P       r  .Macintosh HD:Applications:QuickTime Player.app  *  Q u i c k T i m e   P l a y e r . a p p    M a c i n t o s h   H D  !Applications/QuickTime Player.app   / ��   898 l 

�d:;�d  :   QuickTime Player   ; �<< "   Q u i c k T i m e   P l a y e r9 =�c= l 

�b�a�`�b  �a  �`  �c   � R      �_�^�]
�_ .ascrerr ****      � ****�^  �]   � I  �\>?
�\ .SRBRLog null���    utf8> m  @@ �AA * S t o p   r e c o r d i n g   f a i l e d? �[B�Z
�[ 
LgTyB m  CC �DD 
 E r r o r�Z   � EFE l !!�YGH�Y  G !  Notify Arduino we are done   H �II 6   N o t i f y   A r d u i n o   w e   a r e   d o n eF JKJ I !,�XLM
�X .SRBRSdDtnull���    utf8L o  !"�W�W 0 arduino  M �VN�U
�V 
SnDaN m  %(OO �PP  c�U  K Q�TQ l --�S�R�Q�S  �R  �Q  �T   � RSR = 16TUT o  12�P�P 0 command  U m  25VV �WW 
 d e b u gS X�OX I 9D�NYZ
�N .SRBRLog null���    utf8Y o  9:�M�M 0 	parameter  Z �L[�K
�L 
LgTy[ m  =@\\ �]] 
 D e b u g�K  �O  ��   � ^�J^ l II�I�H�G�I  �H  �G  �J   a m     __�                                                                                  SRBR  alis    H  Serial Bridge              �rB�H+    Serial Bridge.app                                                 �rA�        ����                 Serial Bridge     �rf      �r�       Serial Bridge:Serial Bridge.app   $  S e r i a l   B r i d g e . a p p    S e r i a l   B r i d g e  /Serial Bridge.app  /Volumes/Serial Bridge �    �   Macintosh HD               ƫ�&H+   �gSerialBridge.dmg                                                �h�rC\        ����  	                SerialBridge.dmg.download     ƫ{�      �r,     �g � Ȩ  �  ��  VMacintosh HD:Users:tuupola:Desktop:incoming:SerialBridge.dmg.download:SerialBridge.dmg  "  S e r i a l B r i d g e . d m g    M a c i n t o s h   H D  IUsers/tuupola/Desktop/incoming/SerialBridge.dmg.download/SerialBridge.dmg   /    ��  ��   [ `a` l     �F�E�D�F  �E  �D  a bcb l     �Cde�C  d  	---------   e �ff  - - - - - - - - -c ghg l     �Bij�B  i V P Serial Bridge will call the startCommunication() subroutine after it has opened   j �kk �   S e r i a l   B r i d g e   w i l l   c a l l   t h e   s t a r t C o m m u n i c a t i o n ( )   s u b r o u t i n e   a f t e r   i t   h a s   o p e n e dh lml l     �Ano�A  n Y S the serial port connection for this connection. It is only called after the serial   o �pp �   t h e   s e r i a l   p o r t   c o n n e c t i o n   f o r   t h i s   c o n n e c t i o n .   I t   i s   o n l y   c a l l e d   a f t e r   t h e   s e r i a lm qrq l     �@st�@  s R L port connection has been opened, shortly after Serial Bridge launches or if   t �uu �   p o r t   c o n n e c t i o n   h a s   b e e n   o p e n e d ,   s h o r t l y   a f t e r   S e r i a l   B r i d g e   l a u n c h e s   o r   i fr vwv l     �?xy�?  x 1 + the user presses the Reload Script button.   y �zz V   t h e   u s e r   p r e s s e s   t h e   R e l o a d   S c r i p t   b u t t o n .w {|{ l     �>�=�<�>  �=  �<  | }~} i    � I      �;��:�; (0 startcommunication startCommunication� ��9� o      �8�8  0 connectionname connectionName�9  �:  � O     q��� k    p�� ��� l   �7�6�5�7  �6  �5  � ��� l   �4�3�2�4  �3  �2  � ��� l   �1�0�/�1  �0  �/  � ��� l   �.���.  � L F Loop forever: wait for data, read it, process it, and optionally send   � ��� �   L o o p   f o r e v e r :   w a i t   f o r   d a t a ,   r e a d   i t ,   p r o c e s s   i t ,   a n d   o p t i o n a l l y   s e n d� ��� l   �-���-  �   out serial data.   � ��� "   o u t   s e r i a l   d a t a .� ��,� V    p��� Q   
 k���� k    �� ��� l   ���� r    ��� m    �+�+  ���� o      �*�* "0 maxtimeoutdelay maxTimeoutDelay� #  103.56 days (hex 0x00888888)   � ��� :   1 0 3 . 5 6   d a y s   ( h e x   0 x 0 0 8 8 8 8 8 8 )� ��)� t    ��� n   ��� I    �(��'�( *0 myprocessserialdata MyProcessSerialData� ��&� o    �%�%  0 connectionname connectionName�&  �'  �  f    � o    �$�$ "0 maxtimeoutdelay maxTimeoutDelay�)  � R      �#�"�
�# .ascrerr ****      � ****�"  � �!�� 
�! 
errn� o      �� 0 errnum errNum�   � k   " k�� ��� l   " "����  �� Log timeout errors (-1712) but continue processing loop. Without
				 * handling this error, the script would throw out of the repeat loop
				 * and terminate if any of the script calls were to throw a timeout error.
				 * Normally, if there was a timeout error thrown you would want
				 * to continue processing your main loop in an attempt to get back
				 * in syncronization with the hardware. By catching this error we
				 * will do exactly this and continue to process our script repeat loop.
				    � ����   L o g   t i m e o u t   e r r o r s   ( - 1 7 1 2 )   b u t   c o n t i n u e   p r o c e s s i n g   l o o p .   W i t h o u t 
 	 	 	 	   *   h a n d l i n g   t h i s   e r r o r ,   t h e   s c r i p t   w o u l d   t h r o w   o u t   o f   t h e   r e p e a t   l o o p 
 	 	 	 	   *   a n d   t e r m i n a t e   i f   a n y   o f   t h e   s c r i p t   c a l l s   w e r e   t o   t h r o w   a   t i m e o u t   e r r o r . 
 	 	 	 	   *   N o r m a l l y ,   i f   t h e r e   w a s   a   t i m e o u t   e r r o r   t h r o w n   y o u   w o u l d   w a n t 
 	 	 	 	   *   t o   c o n t i n u e   p r o c e s s i n g   y o u r   m a i n   l o o p   i n   a n   a t t e m p t   t o   g e t   b a c k 
 	 	 	 	   *   i n   s y n c r o n i z a t i o n   w i t h   t h e   h a r d w a r e .   B y   c a t c h i n g   t h i s   e r r o r   w e 
 	 	 	 	   *   w i l l   d o   e x a c t l y   t h i s   a n d   c o n t i n u e   t o   p r o c e s s   o u r   s c r i p t   r e p e a t   l o o p . 
 	 	 	 	  � ��� Z   " k����� =  " %��� o   " #�� 0 errnum errNum� m   # $���P� I  ( /���
� .SRBRLog null���    utf8� m   ( )�� ��� > t i m e o u t   w a i t i n g   f o r   s e r i a l   d a t a� ���
� 
LgTy� m   * +�� ��� 
 E r r o r�  � ��� =  2 5��� o   2 3�� 0 errnum errNum� m   3 4���T� ��� k   8 B�� ��� I  8 ?���
� .SRBRLog null���    utf8� m   8 9�� ��� , A p p l e E v e n t   n o t   h a n d l e d� ���
� 
LgTy� m   : ;�� ��� 
 E r r o r�  � ��� l  @ B���� L   @ B��  � * $ fatal error; exit script processing   � ��� H   f a t a l   e r r o r ;   e x i t   s c r i p t   p r o c e s s i n g�  � ��� =  E H��� o   E F�� 0 errnum errNum� m   F G����� ��� k   K U�� ��� I  K R���
� .SRBRLog null���    utf8� m   K L�� ��� 2 c o n n e c t i o n   s c r i p t   a b o r t e d� ���
� 
LgTy� m   M N�� ��� 
 E r r o r�  � ��
� l  S U���� L   S U�	�	  � * $ fatal error; exit script processing   � ��� H   f a t a l   e r r o r ;   e x i t   s c r i p t   p r o c e s s i n g�
  �  � k   X k�� ��� I  X i���
� .SRBRLog null���    utf8� b   X a��� b   X ]��� m   X [�� ���  e r r o r  � o   [ \�� 0 errnum errNum� m   ] `�� ��� :   i n s i d e   M y P r o c e s s S e r i a l D a t a ( )� ���
� 
LgTy� m   b e�� ��� 
 E r r o r�  � ��� l  j j����  � 9 3return -- maybe fatal error; exit script processing   � ��� f r e t u r n   - -   m a y b e   f a t a l   e r r o r ;   e x i t   s c r i p t   p r o c e s s i n g�  �  � m    	�
� boovtrue�,  � m     ���                                                                                  SRBR  alis    H  Serial Bridge              �rB�H+    Serial Bridge.app                                                 �rA�        ����                 Serial Bridge     �rf      �r�       Serial Bridge:Serial Bridge.app   $  S e r i a l   B r i d g e . a p p    S e r i a l   B r i d g e  /Serial Bridge.app  /Volumes/Serial Bridge �    �   Macintosh HD               ƫ�&H+   �gSerialBridge.dmg                                                �h�rC\        ����  	                SerialBridge.dmg.download     ƫ{�      �r,     �g � Ȩ  �  ��  VMacintosh HD:Users:tuupola:Desktop:incoming:SerialBridge.dmg.download:SerialBridge.dmg  "  S e r i a l B r i d g e . d m g    M a c i n t o s h   H D  IUsers/tuupola/Desktop/incoming/SerialBridge.dmg.download/SerialBridge.dmg   /    ��  ��  ~    l     �� ���  �   ��    i     I      ������ 	0 split    o      ���� 	0 input   	��	 o      ���� 0 	delimiter  ��  ��   k     

  r      n     1    ��
�� 
txdl 1     ��
�� 
ascr o      ���� 0 previous    r     o    ���� 0 	delimiter   n      1    
��
�� 
txdl 1    ��
�� 
ascr  r     n     2   ��
�� 
citm o    ���� 	0 input   o      ���� 
0 output    r      o    ���� 0 previous    n     !"! 1    ��
�� 
txdl" 1    ��
�� 
ascr #��# L    $$ o    ���� 
0 output  ��   %��% l     ��������  ��  ��  ��       ��&'()��  & �������� *0 myprocessserialdata MyProcessSerialData�� (0 startcommunication startCommunication�� 	0 split  ' �� ]����*+���� *0 myprocessserialdata MyProcessSerialData�� ��,�� ,  ���� 0 arduino  ��  * ���������������� 0 arduino  �� 0 incoming  �� 0 previous  �� 0 temp  �� 0 command  �� 0 	parameter  �� 0 
video_file  + 4_������������ ������������������� � ��������� ��� ������� � � ���������0������-��*����@C��O��V\
�� 
ByCt�� 
�� .SRBRWtDtnull���    utf8
�� .SRBRRdDtutf8       utf8
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
�� .SRBRSdDtnull���    utf8��L�H���l O�j E�O��,E�O���,FO��-E�O���,FO��k/E�O��l/E�O�[�\[Zk\Z*��j �� l2E�O�a   H 0a  *j O*j O*a k/j UOa a a l W X  a a a l Y ��a   � aa  U*a k/j  O*a k/a !,a "&E�O*a k/j #Oa $ %��a %,FO�a &*a 'a (/a )a */a +e� ,UOPUOPW X  a -a a .l O�a /a 0l 1OPY �a 2  �a a 3l Y hOPU( �������-.���� (0 startcommunication startCommunication�� ��/�� /  ����  0 connectionname connectionName��  - ��������  0 connectionname connectionName�� "0 maxtimeoutdelay maxTimeoutDelay�� 0 errnum errNum. �������0���������������������  ����� *0 myprocessserialdata MyProcessSerialData��  0 ������
�� 
errn�� 0 errnum errNum��  ���P
�� 
LgTy
�� .SRBRLog null���    utf8���T������ r� n khe �E�O�n)�k+ oW PX  ��  ���l 	Y ;��  ���l 	OhY (��  ���l 	OhY a �%a %�a l 	OP[OY��U) ������12���� 	0 split  �� ��3�� 3  ������ 	0 input  �� 0 	delimiter  ��  1 ���������� 	0 input  �� 0 	delimiter  �� 0 previous  �� 
0 output  2 ������
�� 
ascr
�� 
txdl
�� 
citm�� ��,E�O���,FO��-E�O���,FO�ascr  ��ޭ