///	Francisco Etcheverri C-51
/// EA Algoritmos y estructura de datos UTN 2015
/// Actualizacion 2/11/15

program game_store;

USES crt, dos;

const
color_del_fondo=16;
color_del_texto=15;
cantidad_de_juegos_por_pagina=7;   ///max 19
nombre_del_archivo='Archivo de juegos';

//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////TIPOS ESTRUCTURADOS/////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////


TYPE

datos=record			{Tipo estructurado para la planilla de juegos}
nombre:string;
categoria:string;
marca:string;
consola:string;
precio:real;
stock:word;
juegos_vendidos:word;
end;

listal = ^nodo ;

nodo = record
d:datos;
psig:listal;
end;

mat5=array[1..5] of datos;

archivo=file of datos;  {}

//////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////VARIABLES/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////


VAR
archivo_de_juegos:archivo;
aux,l:listal;
nombre,opcion:string;
i:word;
regjuego:datos;
rta:string;
cantidad_de_opciones,pag:word;
vec_top5_juegosmasvendidos,vec_top5_juegosmas_baratos:mat5;

//////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////PROCEDIMIENTOS////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////


PROCEDURE RECUADRO; begin
	clrscr;
	gotoxy(1,2);
	write('________________________________________________________________________________');
	write('________________________________________________________________________________');
	write('________________________________________________________________________________');
	gotoxy(1,22);
	write('________________________________________________________________________________');
	gotoxy(1,24);
	write('________________________________________________________________________________');
	gotoxy(1,7);
	end;

PROCEDURE GAME_SHOP; begin
	textcolor(12);
	write('G');
	textcolor(11);
	write('A');
	textcolor(14);
	write('M');
	textcolor(13);
	write('E');
	textcolor(14);
	write(' ');
	textcolor(13);
	write('S');
	textcolor(11);
	write('H');
	textcolor(12);
	write('O');
	textcolor(15);
	write('P');
	textcolor(color_del_texto);
end;

PROCEDURE imprimir_menu; begin
    textcolor(color_del_texto);
	clrscr;
	gotoxy(1,1);
	write('________________________________________________________________________________');
	write('____________________________________ INICIO ____________________________________');
	write('________________________________________________________________________________');
	gotoxy(1,8);
	writeln('');
	writeln('                   Aniadir juego a la lista.'); //{ 1}
	writeln('                   Vender juego.');//{ 2}
	writeln('                   Agregar Stock.');//{ 3}
	writeln('                   Modificar planilla de juego.');//{ 4}
	writeln('                   Buscar juego en la lista de stock.');//{5}
	writeln('                   Imprimir todos los juegos en el stock actual.');//{6}
	writeln('                   Eliminar juego de la lista.');//{7}
	writeln('                   Top 5 juegos mas vendidos.');//{8}
	writeln('                   Top 5 juegos mas baratos.');//{9}
	textcolor(Green);
	writeln('                   Guardar en Archivo.'); //{10}
	textcolor(color_del_texto);
	writeln('                   Salir.'); //{11}
	gotoxy(1,22);
	write('________________________________________________________________________________');
	gotoxy(1,23);
	write('________________________________________________________________________________');
	gotoxy(1,24);
	write('________________________________________________________________________________');
	gotoxy(36,6);
	GAME_SHOP;
end;

PROCEDURE como_usar_flechitas; begin
TextBackground (White);
textcolor(Black);
gotoxy(1,25);write('                                                                                ');
gotoxy(1,25);write('Flechitas izquierda y derecha para agregar o quitar stock, enter para confirmar.');
textcolor(color_del_texto);
TextBackground (color_del_fondo);
end;

PROCEDURE como_usar_flechitas_menu; begin
CursorOff;
TextBackground (Yellow);
textcolor(White);
gotoxy(1,12);write('                                                                                ');
gotoxy(1,13);write('                                                                                ');
gotoxy(1,14);write('                                                                                ');
gotoxy(1,13);write('    Flechitas izquierda y derecha para subir y bajar, enter para confirmar.    ');              
textcolor(color_del_texto);
TextBackground (color_del_fondo);
readkey;
CursorOn;
end;

PROCEDURE cantidad_flechitas(x,y:word; op:string; var stock_actual:word); var i:word; ch : char; begin
CursorOff;

i:=stock_actual;
 repeat
    ch:=ReadKey;
    case ch of
     #0 : begin
            ch:=ReadKey;
            case ch of

			
{DERECHA}     #77:begin
						  if (op='restar') then begin
								if (stock_actual<i) then begin
									stock_actual:=stock_actual+1;	
									gotoxy(x,y);	
									write(stock_actual,'    ');
									gotoxy(x,y+4);
								end;
						  end
						  else begin
								stock_actual:=stock_actual+1;	
								gotoxy(x,y);	
								write(stock_actual,'    ');
								gotoxy(x,y+4);
						  end;
						
				    end;
				
{IZQUIERDA}     #75:begin
						  if (op='aniadir') then begin
								if (stock_actual>i) then begin
									stock_actual:=stock_actual-1;	
									gotoxy(x,y);	
									write(stock_actual,'    ');
									gotoxy(x,y+4);
								end;
						  end
						  else begin
								stock_actual:=stock_actual-1;	
								gotoxy(x,y);	
								write(stock_actual,'    ');
								gotoxy(x,y+4);
						  end;
						
				    end;
            end;
         end;
		
		#13: ch:=#13
    end;
  until ch=#13; {ENTER}
 CursorOn;
end;

///X= ALTURA DEL TEXTO, Y=ALTURA DE LA PRIMERA OPCION,
PROCEDURE flechitas(x,y,cantidad_de_opciones:word; var i:word); var ch : char; begin
  i:=y;
  gotoxy(x,y);
  repeat
    ch:=ReadKey;
    case ch of
     #0 : begin
            ch:=ReadKey;
            case ch of
			
{DERECHA}       #77 :begin
					if (y<>cantidad_de_opciones+i-1) then y:=y+1;  			//Si llego hasta la ultima opcion se queda ahi
					gotoxy(70,20);	
					//write('OP:',(y-i+1),' ');
					gotoxy(x,y);write('');					//Mueve el cursor hacia abajo un renglon
				end;
				
{IZQUIERDA}     #75 :begin
					if (y<>i) then  y:=y-1;	   			//Si llego hasta la ultima opcion se queda ahi		
					gotoxy(70,20);	
					//write('OP:',(y-i+1),' ');
					gotoxy(x,y);write('');					//Mueve el cursor hacia abajo un renglon
				end;
            end;
     end;
	
    end;
  until ch=#13; {ENTER}
  i:=(y-i+1);
end;

/////////////////////////Flechitas que al llegar a la opcion 0 o a la maxima+1 salen //////////////////////////
///X= ALTURA DEL TEXTO, Y=ALTURA DE LA PRIMERA OPCION,
PROCEDURE flechitas2(x,y,cantidad_de_opciones:word; var i:word); var ch : char; begin
  i:=y;
  gotoxy(x,y);
  repeat
    ch:=ReadKey;
    case ch of
     #0 : begin
            ch:=ReadKey;
            case ch of
			
{DERECHA}       #77 :begin
					if (y<>cantidad_de_opciones+i-1) then begin 
						y:=y+1;  			//Si llego hasta la ultima opcion se queda ahi
					end else begin
						y:=y+1;  
						ch:=#13;
					end;
					gotoxy(70,20);	
					//write('OP:',(y-i+1),' ');
					gotoxy(x,y);write('');					//Mueve el cursor hacia abajo un renglon
				end;
				
{IZQUIERDA}     #75 :begin
					if (y<>i) then begin
						y:=y-1;	   			//Si llego hasta la ultima opcion se queda ahi		
					end else begin
						y:=y-1;	 
						ch:=#13;						
					end;
					gotoxy(70,20);	
					//write('OP:',(y-i+1),' ');
					gotoxy(x,y);write('');					//Mueve el cursor hacia abajo un renglon
				end;
            end;
     end;
	
    end;
  until ch=#13; {ENTER}
  i:=(y-i+1);
end;

//Flechitas para usar para cambiar de pagina
PROCEDURE flechitas_horizontales(x,y,cantidad_de_opciones:word; var i:word); var ch : char; begin
 cantidad_de_opciones:=cantidad_de_opciones+1;
 i:=x;
  gotoxy(x,y);
  repeat
    ch:=ReadKey;
    case ch of
     #0 : begin
            ch:=ReadKey;
            case ch of
			
{DERECHA}       #77 :begin
					if (x<>i+cantidad_de_opciones+cantidad_de_opciones-2) then
					x:=x+2;  			
					gotoxy(70,20);	
					//write('OP:',((x-i+2)/2):2:0,' ');
					gotoxy(x,y);write('');					
				end;
				
{IZQUIERDA}     #75 :begin
					if  (x<>i) then begin
					x:=x-2;	   			
					gotoxy(70,20);	
					//write('OP:',((x-i+2)/2):2:0,' ');
					gotoxy(x,y);write('');		
					end else begin
						//ch:=#13;
					end;
				end;
            end;
     end;
	
    end;
  until ch=#13; {ENTER}
  i:=x-i+2;
  i:=round(i/2)
end;

//Procedimiento para eleccion del tipo de consola
PROCEDURE cargar_registro_consola(var consola:string; y:word); var i:word; begin
	writeln('Ingrese de que tipo de consola es el juego.');
	writeln('');
	writeln('-PC');
	writeln('-PS3');
	writeln('-PS4');
	writeln('-XBOX');
	writeln('-XBOX ONE');
	flechitas(1,3+y,5,i); ////+6 por el recuadro de arriba
	case i of
		1:consola:='PC';
		2:consola:='PS3';
		3:consola:='PS4';
		4:consola:='XBOX';
		5:consola:='XBOX ONE';
	end;
end;

PROCEDURE validar_numero(numero_string:string; VAR numero_entero:word; VAR rta:word); begin
val(numero_string,numero_entero,rta);
if(rta<>0)then begin
	writeln('(',numero_string,') no es un numero valido.');
	readkey;
end;

end;

PROCEDURE cargar_registro(VAR rj:datos); var numero_string:string; numero_entero,rta:word; begin									{#######################     Cargar planilla de juego con los datos       #######################}
	RECUADRO;
	writeln('Ingrese nombre del Juego.');
	readln(rj.nombre);
	clrscr;
	RECUADRO;
	writeln('Ingrese categoria.');
	readln(rj.categoria);
	if (rj.categoria='') then rj.categoria:='              ';
	clrscr;
	RECUADRO;
	writeln('Ingrese marca.');
	readln(rj.marca);
	if (rj.marca='') then rj.marca:='              ';
	clrscr;
	RECUADRO;
	cargar_registro_consola(rj.consola,6);
	rta:=9999;
	while(rta<>0)do begin
		clrscr;
		RECUADRO;
		writeln('Ingrese precio.');
		write('$');
		readln(numero_string);
		validar_numero(numero_string,numero_entero,rta);
	end;
	rj.precio:=numero_entero;
	rta:=9999;
	while(rta<>0)do begin
		clrscr;
		RECUADRO;
		writeln('Ingrese stock  inicial del producto');
		readln(numero_string);
		validar_numero(numero_string,rj.stock,rta);
	end;
	
	clrscr;
	rj.juegos_vendidos:=0;
end;

PROCEDURE imprimir_registro(rj:datos;x,y:word); begin									{#######################     Imprimir planilla de juegos con los datos    #######################}
	gotoxy(x,y); writeln('Nombre: ',rj.nombre);
	y:=y+1;
	gotoxy(x,y); writeln('Categoria: ',rj.categoria);
	y:=y+1;
	gotoxy(x,y); writeln('Marca: ',rj.marca);
	y:=y+1;
	gotoxy(x,y); writeln('Consola: ',rj.consola);
	y:=y+1;
	gotoxy(x,y); writeln('Precio: $',rj.precio:4:0);
	y:=y+1;
	gotoxy(x,y); writeln('Stock actual: ',rj.stock);
end;

PROCEDURE insertar_ordenado ( var l:listal; rj:datos); var anterior, actual,nuevo:listal; begin {#######################    Insertar ordenado              #######################}
	new (nuevo);
	nuevo^.d:=rj;
	anterior:=nil;
	actual:=l;
	while (actual <> nil)and     (actual^.d.nombre<rj.nombre) do begin
	  anterior:=actual;
	  actual:=actual^.psig;
	  end;
	
	  if (anterior <> nil) then begin
	      anterior^.psig:=nuevo;
	      nuevo^.psig:=actual;
	   end;
	
	  if (anterior = nil) then begin	
	  	nuevo^.psig:=l;
	  	l:=nuevo;
	  end;
end;

PROCEDURE insertar_al_inicio(VAR l:listal; rj:datos); var nuevo:listal; begin 	{#######################      Insertar ordenado                           #######################}
	new(nuevo);
	nuevo^.d:= rj;
	nuevo^.psig:=l;
	l:=nuevo;
end;

PROCEDURE menu_eliminar;var i:word; begin
clrscr;
CursorOff;
gotoxy(36,10);
write('CARGANDO');
gotoxy(15,14);
TextBackground (White);
write('                                                  ');
TextBackground ( red );
gotoxy(15,14);
for i:=1 to 50 do begin
	Write(' ');
	Delay(15); {Wait one second}
end;
TextBackground (Black);
gotoxy(25,10);
write('Juego eliminado correctamente');
gotoxy(17,20);
CursorOn;
sound(50);
write('Presione una tecla cualquiera para continuar..');
readkey;
end;

PROCEDURE eliminar_elemento_de_lista(VAR nom:string; VAR l:listal); var anterior,actual:listal; begin
	anterior:=nil;
	actual:=l;
	while((actual<>nil)and(actual^.d.nombre<>nom)) do begin
		anterior:=actual;
		actual:=actual^.psig
	end;
	
	
	if (actual=nil) then begin
		writeln('Juego no encontrado.');
		readkey;
	end
	else begin
		if(anterior=nil) then begin  ////CASO PRIMER NODO ES EL BUSCADO
			    //Mover la lista, eliminar anterior
			l:=actual^.psig; ////Tomi  lcdth
			dispose(actual);
		end
		ELSE begin
			anterior^.psig:=actual^.psig;
			dispose(actual);
			menu_eliminar;
		end;	
	end;
end;

////PROCEDIMIENTO ''Recursivo''
PROCEDURE modificar_elemento(var rj:datos); var numero_string:string; numero_entero,rta:word; begin
			rta:=999;
			writeln(' ');
			writeln(' Volver al menu principal');
			imprimir_registro(rj,2,4);
			flechitas(1,3,7,i); ////7 por la opcion de salir
			clrscr;
			case i of
				2:	begin writeln('Ingrese nombre del Juego.'); readln(rj.nombre); end;
				3:	begin writeln('Ingrese categoria.'); readln(rj.categoria); end;
				4:	begin writeln('Ingrese marca.'); readln(rj.marca);  end;
				5:	begin cargar_registro_consola(rj.consola,0); end;
				6:	begin while(rta<>0)do begin
							clrscr;
							RECUADRO;
							writeln('Ingrese precio.');
							write('$');
							readln(numero_string);
							validar_numero(numero_string,numero_entero,rta);
						end;
						rj.precio:=numero_entero;
				end;
				
				7:	begin while(rta<>0)do begin
							clrscr;
							RECUADRO;
							writeln('Ingrese cantidad de stock.');
							write('$');
							readln(numero_string);
							validar_numero(numero_string,numero_entero,rta);
						end;
				end;
			end;
			clrscr;
			if (i<>1) then begin
			writeln('Decea modificar algun otro campo ?');
			modificar_elemento(rj); //// En caso de que sea 7 salir
			end;
			
end;

///////RECURSION////////////////////////////////////////////////////////////////////////////////
PROCEDURE buscar_juego_recursivo(VAR aux:listal; nom:string); begin
	if ((aux<>nil) and (aux^.d.nombre<>nom)) then begin
		aux:=aux^.psig;
		buscar_juego_recursivo(aux,nom);
		//buscar_juego_recursivo(aux^.psig,nom);
	end;
end;

PROCEDURE Busqueda_avanzada(VAR op:string); var j:word; begin
		gotoxy(1,14);
		writeln('-Vender.');
		writeln('-Agregar stock.');
		writeln('-Modificar.');
		writeln('-Eliminar.');
		writeln('-Salir.');
		flechitas(1,14,5,j); ///+ op salir
		gotoxy(1,20);
		clrscr;
		case(j)of
			1:  op:='venta';
								
			2: op:='agregar_stock';
								
			3: op:='modificar_juego';
							
			4: op:='Eliminar';
			
			5: op:='Salir';
			end;
end;

PROCEDURE buscar_juego(aux:listal; VAR nom:string; op:string); var j:word; begin {#######################    Buscar juego distintas opciones    #################}
	
	buscar_juego_recursivo(aux,nom);
	
{	while ((aux<>nil) and (aux^.d.nombre<>nom)) do begin
		aux:=aux^.psig;
	end;}
	
	if (aux=nil) then begin
		writeln('Juego no encontrado.');
		readkey;
	end 
	else begin
		CASE op of 
		
			'busqueda':begin imprimir_registro(aux^.d,1,7); end;
			
			'venta':begin
						if (aux^.d.stock<1) then begin
								writeln('El juego ',aux^.d.nombre,' no posee Stock suficiente para realizar la venta.');
								writeln('');
							end
						ELSE begin
								aux^.d.stock:=aux^.d.stock-1;
								aux^.d.juegos_vendidos:=aux^.d.juegos_vendidos+1;
								write('Venta realizada, el ');
						end;
						write('Stock actual: ',aux^.d.stock,'.');
						
			END;											
			
			'agregar_stock': begin
						como_usar_flechitas;
						gotoxy(1,1); write('Stock actual: ',aux^.d.stock);
						cantidad_flechitas(15,1,'aniadir',aux^.d.stock);
						clrscr;
						
			end;{AGREGAR STOCK}
			
			'modificar_juego': begin	
				writeln('Que campo desea modificar ?');
				modificar_elemento(aux^.d);
					
			end;
			
		end;{CASE}			
    	
	end;{else}
end;

PROCEDURE menu_varios_juegos; begin
	TextBackground ( White );       { Con fondo azul }
	textcolor(Black);
	gotoxy(1,1);
	write('                                                                                ');	
	write(' BUSCAR JUEGO:                                                                  ');
	write('                                                                                ');
	write(' Juego                        Categoria     Marca        Consola   Stock  Precio');
	write('                                                                                ');
	textcolor(color_del_texto);
	TextBackground ( Black );
	gotoxy(16,2);
	write('                             ');
	gotoxy(16,2);
end;

PROCEDURE imprimir_cant_pag(VAR cant_pag:word); var x,i:word; begin
	x:=29;	
	for i:=1 to cant_pag do begin		/// Imprimir los numeros de la cantidad de paginas
	
			gotoxy(x,25);
			write(i,' ');
			x:=x+2;
	end;
	gotoxy(x,25); write('SALIR')
end;
   
PROCEDURE cargar_datos_paginas(aux:listal; VAR cant_pag:word; VAR cant_ult_pag:word); var i:word; contador:word; begin
	contador:=0;
	i:=0;
	cant_pag:=1;
	cant_ult_pag:=1;
	if(aux<>nil)then while(aux^.psig<>nil) do begin ////Cantidad de paginas que ocupa la lista en la pantalla en {cant_pag}
		contador:=contador+aux^.d.stock;
		if (i<cantidad_de_juegos_por_pagina) then begin
			i:=i+1;
		end else begin
			cant_pag:=cant_pag+1;
			i:=1;
		end;
		aux:=aux^.psig;
	end;

	if (i<>0) then cant_ult_pag:=i;
	clrscr;
	gotoxy(1,1);writeln('Cantidad de juegos en stock total = ',contador);
	readkey;
end;   

PROCEDURE imprimir_un_registro_en_forma_de_lista(VAR y:word; rj:datos); var x:word; begin
	x:=1;
	gotoxy(x,y); write(' ',rj.nombre);
	x:=30;
	gotoxy(x,y); write(' ',rj.Categoria);
	x:=44;
	gotoxy(x,y); write(' ',rj.marca);
	x:=57;
	gotoxy(x,y); write(' ',rj.consola);
	x:=67;
	gotoxy(x,y); write(' ',rj.stock);
	x:=74;
	gotoxy(x,y); write(' $',rj.precio:4:0);
	y:=y+1;
end;

PROCEDURE Imprimir_varios_juegos(VAR l:listal; pag:word); var aux,aux2:listal; cantidad_de_juegos_ultima_pag,cantidad_de_juegos_pagina_actual,puntero,x,y,i,cant_pag,op:word; opcion,nombre:string; begin
	clrscr;
	aux:=l;
	op:=1;
	cant_pag:=0;
	cargar_datos_paginas(l,cant_pag,cantidad_de_juegos_ultima_pag); //Cantidad total de paginas // Cantidad de juegos en la ultima pagina

	writeln(cant_pag);				 ///Programador<----
	writeln(cantidad_de_juegos_ultima_pag); 
	readln;
	
	while(op<>cant_pag+1) do begin    //Cuando la opcion no sea salir 
		y:=6;
		if (cant_pag=1)or(op=cant_pag) then begin 										//imprimir paginas que no estan llenas
			clrscr;
			menu_varios_juegos;
			
			cantidad_de_juegos_pagina_actual:=cantidad_de_juegos_ultima_pag;   ///La pagina es la ultima, puede ser tambien la unica
			if (cantidad_de_juegos_ultima_pag<>1)then begin
			cantidad_de_juegos_pagina_actual:=cantidad_de_juegos_pagina_actual+1;
				for i:=1 to (cantidad_de_juegos_pagina_actual) do begin  	///IMPRIMIR PAGINA NO LLENA
					imprimir_un_registro_en_forma_de_lista(y,aux^.d);
					aux:=aux^.psig;
				end;
			end 
			else begin   ////Un unico juego en la lista
				imprimir_un_registro_en_forma_de_lista(y,aux^.d);
			end;
		end
		
		else begin if (op<>cant_pag) then begin 									    //Imprimir paginas llenas 
				clrscr;
				menu_varios_juegos;
				cantidad_de_juegos_pagina_actual:=cantidad_de_juegos_por_pagina;
				for i:=1 to cantidad_de_juegos_por_pagina do begin  	///IMPRIMIR PAGINA NO LLENA
					imprimir_un_registro_en_forma_de_lista(y,aux^.d);
					aux:=aux^.psig;
				end;  
			end;
		end;
		
		imprimir_cant_pag(cant_pag);							 					    //Imprimir numero de las paginas
		flechitas2(1,6,cantidad_de_juegos_pagina_actual,puntero);

{//////////////////////////////////////Menu ya impreso y menu de paginas desplegado////////////////////////////////////////////}	

		if (puntero=0) then begin				   										//Buscar juego
			gotoxy(16,2);
			readln(nombre);
			clrscr;
				aux:=l;
				buscar_juego_recursivo(aux,nombre);	
				if (aux<>nil) then begin
					imprimir_registro(aux^.d,1,7);
					if (nombre<>'juego no encontrado')	then begin
						Busqueda_avanzada(opcion);
						if (opcion='Eliminar') then begin 
							eliminar_elemento_de_lista(nombre,l); 
						end 
						else begin
							buscar_juego(l,nombre,opcion);
						end;
					end;
				end
				else begin
					writeln('Juego no encontrado.');
				end;
			aux:=l;
			readkey;
			
		end
	
		else begin	
		
		if (puntero<>(cantidad_de_juegos_pagina_actual+1)) AND (puntero<>0) then begin  //Seleccionar juego y buscarlo
				clrscr;			
				writeln('Puntero=',puntero);
				writeln('OP=',op);
				writeln('Cantidad de veces que se va a repetir aux^.psig=',(((op-1)*6)+puntero));
				readkey; ////Ayuda para programador
				aux2:=l;
			
				for i:=1 to ((((op-1)*cantidad_de_juegos_por_pagina)+puntero)-1) do begin    ///Numero de pagina por orden del juego en la pag es igual a la cantidad de veces que repito el psig
					aux2:=aux2^.psig;
				end;
			
				imprimir_registro(aux2^.d,1,7);
				Busqueda_avanzada(opcion);
				if (opcion='Eliminar') then begin
					writeln('Juego ',aux2^.d.nombre,' eliminado.');
					eliminar_elemento_de_lista(aux2^.d.nombre,l);
				op:=cant_pag+1;   //Salir al menu principal
				
					Delay(1500); 
				end else begin if (opcion<>'Salir') then begin
						buscar_juego(aux2,aux2^.d.nombre,opcion);
					end;
					puntero:=cantidad_de_juegos_pagina_actual+1; //// Para cargar las paginas 
					gotoxy(28,23);
					writeln('Volver a la pagina...');
					end;
				end;
		
		if (puntero=(cantidad_de_juegos_pagina_actual+1)) then begin 					//Menu de flechitas
				imprimir_cant_pag(cant_pag);
				flechitas_horizontales(29,25,cant_pag,op);
				//////ELEGIR A QUE PAGINA IR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
{############################   Cambiar puntero a..   ###################################}				

				if (op=1) then begin 
					aux:=l;
				end else begin 
					aux:=l;
					for i:=1 to (cantidad_de_juegos_por_pagina*(op-1)) do begin
							if(aux<>nil) then begin
								aux:=aux^.psig;
							end;
					end;
				end;
			end;

end;			
END;{WHILE}
clrscr;
end;

PROCEDURE imprimir_vector5(v:mat5; l,aux:listal);  var op,y,i:word; opcion:string; begin
write('                                                                                ');
write(' N  Juego                       Marca         Vendidos  Consola  Stock  Precio  ');
write('                                                                                ');
TextBackground ( Black );
y:=8;
for i:=1 to 5 do begin
	gotoxy(2,y);write(i);
	gotoxy(4,y); write(' ',v[i].nombre);
	gotoxy(32,y);write(' ',v[i].marca);
	gotoxy(46,y);write(' ',v[i].juegos_vendidos);	
	gotoxy(56,y);write(' ',v[i].consola);
	gotoxy(65,y); write(' ',v[i].stock);
	gotoxy(72,y); write(' $',v[i].precio:4:0);
	y:=y+1;
end;
gotoxy(1,y);write(' Salir'); readkey;

end;

PROCEDURE Vector_juegos_mas_vendidos(aux:listal; v:mat5); VAR i,j,max:word; begin

while(aux<>nil) do begin
i:=1;
while i<>6 do begin
	if (v[i].juegos_vendidos < aux^.d.juegos_vendidos) then begin
		v[i]:=aux^.d;
		i:=6;
	end else begin
		i:=i+1;
	end;
end;
aux:=aux^.psig;
end;{END WHILE}
TextBackground (red);
write('                                                                                ');
write('                            TOP5 JUEGOS MAS VENDIDOS                            ');
write('                                                                                ');
imprimir_vector5(v,aux,aux);
end;{END PROCEDIMIENTO}

PROCEDURE Vector_juegos_mas_baratos(aux:listal; v:mat5); VAR i,j,max:word; begin
for i:=1 to 5 do begin
v[i].precio:=99999;
end;

while(aux<>nil) do begin
i:=1;
while i<>6 do begin
	if (v[i].precio > aux^.d.precio) then begin
		v[i]:=aux^.d;
		i:=6;
	end else begin
		i:=i+1;
	end;
end;
aux:=aux^.psig;
end;{END WHILE}
TextBackground (Green);
write('                                                                                ');
write('                             TOP5 JUEGOS MAS BARATOS                            ');
write('                                                                                ');
imprimir_vector5(v,aux,aux);
end;{END PROCEDIMIENTO}

PROCEDURE cargar_a_archivo(l:listal; VAR archivo:archivo); VAR aux:listal; begin
assign(archivo,'C:\Users\frNN\Desktop\archivo_de_juegos.dat');
reset(archivo);
aux:=l;
while (aux<>nil) do begin
	write(archivo,aux^.d);
	aux:=aux^.psig;
end;
close(archivo);
end;

PROCEDURE ArchivoNuevo(l:listal;var archivo:archivo); VAR nom:string; aux:listal; begin
aux:=l;
//ASIGNAMOS UN NOMBRE PARA EL ARCHIVO DE DATOS A CREAR

assign(archivo,nombre_del_archivo);
rewrite(archivo);

while (aux<>nil) do begin
     Write(archivo,aux^.d);
     aux:=aux^.psig;
end;
close(archivo);
end;

PROCEDURE cargadesdearchivo(var archivo:archivo;VAR l:listal); var rj:datos; nom:string; begin
l:=nil;
clrscr;
{$I-}                  
assign(archivo,nombre_del_archivo);
reset(archivo); ///Abrir
{$I+}
if ioresult=0 then begin
    while (not eof (archivo)) do begin
		read(archivo,rj);        //Se carga un registro auxiliar con un registro del archivo
		insertar_ordenado(l,rj); //Se agrega el registro auxiliar a la lista ordenada
    end;
	close(archivo);
end 
else begin
	ArchivoNuevo(l,archivo);
end;
clrscr;
End;

{CREAR Archivo secuencial que sirva como backup y que dsp calcule si hay repetidos y lo ordene para su post carga}
PROCEDURE menu_cargar_archivo;var i:word; begin
clrscr;
CursorOff;
gotoxy(36,10);
write('CARGANDO');
gotoxy(15,14);
TextBackground (White);
write('                                                  ');
TextBackground ( Green );
gotoxy(15,14);
for i:=1 to 50 do begin
	Write(' ');
	Delay(15); {Wait one second}
end;
TextBackground (Black);
gotoxy(25,10);
write('ARCHIVO GUARDADO CORRECTAMENTE');
gotoxy(17,20);
CursorOn;
sound(50);
write('Presione una tecla cualquiera para continuar..');
readkey;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////PROGRAMA PRINCIPAL///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

begin
clrscr;
como_usar_flechitas_menu;
clrscr;
i:=0;
cantidad_de_opciones:=11;
cargadesdearchivo(archivo_de_juegos,l);
while (i<>cantidad_de_opciones) do begin
imprimir_menu;
flechitas(19,9,cantidad_de_opciones,i);
clrscr;
	CASE (i) OF

		1: begin {####     CARGAR REGISTRO Y AÑADIR A LA LISTA           ####}
				cargar_registro(regjuego);	
				writeln('Desea modificar algun campo?');
				modificar_elemento(regjuego);
				//insertar_al_inicio(l,regjuego);
				insertar_ordenado(l,regjuego);
			end;
		
		2: begin {####    Vender juego          ####}
				writeln('Ingrese nombe de juego que juego desea vender ?');
				readln(nombre);
				clrscr;
				buscar_juego(l,nombre,'venta');
				clrscr;
			end;
		
		3: begin {####    AGREGAR STOCK          ####}
				writeln('Ingrese nombe de juego que juego desea reponer stock ?');
				readln(nombre);
				clrscr;	
				buscar_juego(l,nombre,'agregar_stock');
				clrscr;
			end;
		
		4: begin {####    MODIFICAR PLANILLA DEL JUEGO      ####}
				writeln('Ingrese nombe de juego que juego desea desea modificar ?');
				readln(nombre);
				clrscr;
				buscar_juego (l, nombre,'modificar_juego');
				clrscr;
			end;
		
		5:  begin {####    BUSCAR JUEGO    ####### }
				
				writeln('Ingrese nombe de juego que juego desea buscar ?');
				readln(nombre);
				clrscr;
				aux:=l;
				buscar_juego_recursivo(aux,nombre);	
				if (aux<>nil) then begin
					imprimir_registro(aux^.d,1,7);
					if (nombre<>'juego no encontrado')	then begin
						Busqueda_avanzada(opcion);
						if (opcion='Eliminar') then begin 
							eliminar_elemento_de_lista(nombre,l); 
						end 
						else begin
							buscar_juego(l,nombre,opcion);
						end;
					end;
				end
				
				else begin
					writeln('Juego no encontrado.');
					readkey;
				end;
				
			end;
		
		6:  begin {####    Imprimir todos los juegos }
				if (l<>nil) then begin 
					Imprimir_varios_juegos(l,pag);
				end 
				else begin
					gotoxy(18,12);
					write('Ingrese por lo menos un juego para comenzar..');
					readkey;
				end;
			end;
			
		7:  begin {####    Eliminar juego }
				writeln('Ingrese nombe de juego que juego desea eliminar?');
				readln(nombre);
				clrscr;
				eliminar_elemento_de_lista(nombre,l);
				
			end;
		
		8:  begin {####    Vector juegos mas vendidos }	
				Vector_juegos_mas_vendidos(l,vec_top5_juegosmasvendidos);
			end;
			
		9:  begin {####    Vector juegos mas baratos }				
				Vector_juegos_mas_baratos(l,vec_top5_juegosmasvendidos);
			end;
			
		10: begin
			ArchivoNuevo(l,archivo_de_juegos);
			menu_cargar_archivo;
			end;
		end;
end;
ArchivoNuevo(l,archivo_de_juegos);
end.