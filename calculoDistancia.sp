------------------------------------------------------------------------------------
-- Leandro N. Acevedo                                                             --
-- 26/05/2021                                                                     --
-- Encuentra la distancia mas corta entre dos puntos A y B a partir de una tabla  --
------------------------------------------------------------------------------------

CREATE PROCEDURE calculoDistancia (@strt VARCHAR (5), @end VARCHAR (5), @color varchar(5) = null)
AS
DECLARE
@Estacion varchar(5),
@iniFin	int
BEGIN
   SET NOCOUNT ON;
   
   SELECT @iniFin = 1
   
   IF ascii(@strt) > ascii(@end)
   BEGIN
   		SELECT @iniFin = 0
   END;

		
   
   /* Query Recursivo para el calculo de la menor distancia*/
   WITH Tabla1
   AS (SELECT CASE WHEN @iniFIn = 1 THEN PB
       			   ELSE PA
       		  END PB,
         CASE 
            WHEN PA IS NULL
               THEN 
       				CASE WHEN @iniFin = 1  THEN CAST (ISNULL (PA, PB) + '-' AS VARCHAR (MAX))
       					 				   ELSE CAST (ISNULL (PB, PA) + '-' AS VARCHAR (MAX))
      				END
            WHEN PA IS NOT NULL
               THEN 
       				CASE WHEN @iniFin = 1  THEN CAST (PA + '-' + PB AS VARCHAR (MAX))
       								       ELSE CAST (PB + '-' + PA AS VARCHAR (MAX))
       				END
            END FullPath,
		 CASE	
			WHEN COLOR = @color or COLOR IS NULL
				THEN Distance
			ELSE
				0
		 END TotalDistance
      FROM Estaciones
      WHERE ((@iniFin = 1 AND (PA = @strt))
      OR  (@iniFin = 0 AND (PB = @strt)))
      UNION ALL
      SELECT CASE WHEN @iniFin = 1 THEN a.PB
       			  ELSE a.PA
       			  END,
			 CASE WHEN @iniFin = 1 THEN c.FullPath  + '-' + a.PB 
       			  ELSE c.FullPath + '-' + a.PA 
       			  END FullPath,
			 CASE	
				when a.color = @color or a.color is null
					then TotalDistance + a.Distance 
				else	
					TotalDistance 
			 END TotDistance
      FROM Estaciones a, Tabla1 c
      WHERE ((@iniFin = 1 and a.PA = c.PB)
      OR (@iniFin = 0 and a.PB = c.PB))
      ),
   Tabla2
   AS (SELECT *, RANK () OVER (ORDER BY TotalDistance) BestPath
      FROM Tabla1
      WHERE PB = @end AND PATINDEX ('%' + @end + '%', FullPath) > 0)
   
	
	/*Creo tabla temporal de trabajo*/
   SELECT FullPath, TotalDistance
   INTO mejorCamino
   FROM Tabla2
   WHERE BestPath = 1; 
   
   /*Creo un cursor para eliminar las estaciones que no corresponden al color*/
   declare borrarEstaciones cursor for
   Select PA
   from Estaciones 
   where color <> @color
   and color is not null
   
   open borrarEstaciones
   FETCH NEXT FROM borrarEstaciones   
   INTO @Estacion
  
	WHILE @@FETCH_STATUS = 0  
	BEGIN
		update mejorCamino
		set FullPath = replace(FullPath,'-' + @Estacion,'')
		
		FETCH NEXT FROM borrarEstaciones   
		INTO @Estacion
	END
	
	CLOSE borrarEstaciones  
    DEALLOCATE borrarEstaciones 
	
	/*Seleccione los paths mas cortos*/
	Select FullPath MejorCamino
	from mejorCamino;
	
	/*Dropeo la tabla temporal de trabajo*/
	drop table mejorcamino;

   SET NOCOUNT OFF
END
