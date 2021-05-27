DECLARE
@partida varchar(5),
@llegada varchar(5),
@color   varchar(5) = null

Select @partida = 'A',
	   @llegada = 'F',
       @color   = 'ROJO'
       
exec calculoDistancia @partida, @llegada, @color