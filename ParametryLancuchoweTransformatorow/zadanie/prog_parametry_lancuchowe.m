
% PROGRAM DO OBLICZENIA PARAMETR�W LINI ELEKTROENERGETYCZNEJ
%A- macierz �a�cuchowa 1 transformatora
%B- macierz �a�cuchowa linii napowietrznej
%C- macierz �a�cuchowa 2 transformatora
%D- macierz �a�cuchowa ca�ego uk�adu  D=A*B*C

clc
clear
format short e
%ZMIENNE POMOCNICZE 
f=50;           %[Hz]             %cz�stotliwo�� napi�cia zasilaj�cego
omega=2*pi*f;   %[1/s]            %pulsacja 
%PARAMETRY TRAFO 1 :

Sn1= 31.5;      %[MVA]            %moc znamionowa trafo [MVA]
Up1= 6 ;        %[kV]             %napi�cie pierwotne
Uw1=110 ;       %[kV]             %napi�cie wt�rne
deltaUz1= 10.5; %[%]              %napi�cie zwarcia 
deltaPcu1= 200; %[kW]             %straty w miedzi
deltaPfe1= 80 ; %[kW]             %straty w zelazie
Io1= 2.8 ;      %[%]              %pr�d biegu ja�owego 

%PARAMETRY TRAFO 2 :

Sn2= 16  ;        %[MVA]          %moc znamionowa trafo [MVA]
Up2= Uw1;         %[kV]           %napi�cie pierwotne jest r�wne napi�ciu wt�rnemu transformatora 1 logiczne 
Uw2=20;           %[kV]           %napi�cie wt�rne
deltaUz2= 10.5;   %[%]            %napi�cie zwarcia 
deltaPcu2= 136;   %[kW]           %straty w miedzi
deltaPfe2= 47.5 ; %[kW]           %straty w zelazie
Io2= 3.1;         %[%]            %pr�d biegu ja�owego 

%PARAMETRY LINIA:

L=200 ;           %[km]  %d�ugo�� linii 
S=150;            %[mm^2]  %przekr�j linii
b= 5 ;            %[m] odleg�o�� mi�dzy przewodami 
R0=0.2045;         %[?/km] rezystancja jednostkowa linii



%OBLICZANIE PARAMETR�W TRANSFORMATOR�W :
%TRAFO 1:
Rt1= ((deltaPcu1*10^-3)*(Uw1^2))/(Sn1^2);     %rezystancja transformatora
Zt1=((deltaUz1*(Uw1^2))/(100*Sn1));
if Sn1>2.5
   Xt1=Zt1;
else Xt1=sqrt(Zt1^2-Rt1^2);
end
%b�d� sprawdza� napi�cie wt�rne TRAFO 1 i napiecie pierwotne TRAFO 2 je�li
%Uw1<=30kV to bior� czw�rnik dla U<=30kV i tak samo dla Up2
if Uw1<=30
    Zzt1= Rt1+Xt1*1i;                         %impedancja zast�pcza transformatora
   A=[1, Zzt1; 0, 1];                         % macierz �a�cuchowa dla trafo 1
else 
    Gt1=((deltaPfe1*10^-3)/(Uw1^2));          %konduktancja trafo 1
    Bt1= -((Io1*Sn1)/(100*(Uw1^2)));          %susceptancja
    
    Zzt1= Rt1+Xt1*1i;                         %impedancja zast�pcza trafo 1
    Yzt1=Gt1+Bt1*1i;                          %impedancja zast�pcza trafo 1
   disp('A- macierz �a�cuchowa 1 transformatora')
    A=[1+Zzt1*Yzt1, Zzt1; Yzt1, 1]           % macierz �a�cuchowa dla trafo 1

end



%TRAFO 2:
Rt2= ((deltaPcu2*10^-3)*(Up2^2))/(Sn2^2);     %rezystancja transformatora
Zt2=((deltaUz2*(Up2^2))/(100*Sn2));           %impedancja trafo 2
if Sn2>2.5                                    %je�li moc znamionowa wi�ksza ni� 2.5 MVA 
   Xt2=Zt2;
else Xt2=sqrt(Zt2^2-Rt2^2);
end
%b�d� sprawdza� napi�cie wt�rne TRAFO 1 i napiecie pierwotne TRAFO 2 je�li
%Uw1<=30kV to bior� czw�rnik dla U<=30kV i tak samo dla Up2
if Up2<=30
    Zzt2= Rt2+Xt2*1i;                         %impedancja zast�pcza transformatora
   C=[1, Zzt2; 0, 1];                         % macierz �a�cuchowa dla trafo 2
else 
    Gt2=((deltaPfe2*10^-3)/(Up2^2));          %konduktancja trafo 2
    Bt2= -((Io2*Sn2)/(100*(Up2^2)));          %susceptancja trafo 2
    
    Zzt2= Rt2+Xt2*1i;                         %impedancja zast�pcza trafo 2
    Yzt2=Gt2+Bt2*1i;                          %impedancja zast�pcza trafo 2
    disp('C- macierz �a�cuchowa 2 transformatora')
    C=[1, Zzt2; Yzt2,1+Zzt2*Yzt2]           % macierz �a�cuchowa dla trafo 2

end



%OBLICZANIE PARAMETR�W LINII NAPOWIETRZNEJ :

Rln=R0*L;                                     %Rezystancja linii 3 faz
bsr=(((b^2)*2*b)^(1/3))*1000;                 %�redni odst�p mi�dzy przewodami dla linii tr�jfazowych , 
                                              %jednotorowych  o niesymetrycznym uk�adzie przewod�w *1000 bo zamienia
r=sqrt(S/pi);                                 %promie� przewod�w                              
L0=(4.6*log10(bsr/r)+0.5)*10^-4;                %indukcyjno�� robocza jednej fazy w [H/km] /dla AFL
X0=omega*L0;                                  %reaktancja jednostkowa linii [?/km] 
Xln=X0*L;                                     %Reaktancja linii napowietrznej

if Uw1<=30 
    Zzl=Rln+Xln*1j;                           %impedancja zast�pcza linii                    
    B=[1,Zzl;0,1];
else % Uw1>30&Uw1<400
    Zzl=Rln+Xln*1j;                           %impedancja zast�pcza linii  
    B0=omega*(0.02415/(log10(bsr/r)))*10^-6;    %susceptancja jednostkowa[S/km]
    Bln=B0*L;
    Yzl=(Bln/2)*1j;
    disp('B- macierz �a�cuchowa linii napowietrznej')
    B=[1+(Zzl*Yzl),Zzl;2*Yzl+Yzl*Yzl*Zzl,1+(Zzl*Yzl)]
% tutaj m�g�bym doda� warunek powy�ej 400kV ale nie znam start mocy delta Po
 %   Zzl=Rln+Xln*1j;                           %impedancja zast�pcza linii  
 %   B0=omega*(0.02415/(log10(bsr/r)))*10^-6;    %susceptancja jednostkowa[S/km]
 %   Bln=B0*L;
 %   G0=                                        %konduktancja jednostkowa
 %   Yzl=(Bln/2)*1j;
end
disp('D- macierz �a�cuchowa ca�ego uk�adu  D=A*B*C')
D=A*B*C 




















