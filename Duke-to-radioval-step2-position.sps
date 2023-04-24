*Duke Position.

STRING PositionBACK(A255).

COMPUTE PositionBACK=Position.

STRING Position2(A255).

COMPUTE Position2=Position.

*Cleanup.

*remove secondary tumor location.
DO IF (TumorLocation='L').
COMPUTE Position2=REPLACE(Position2,'R','').
ELSE IF (TumorLocation='R').
COMPUTE Position2=REPLACE(Position2,'L','').
else if (TumorLocation='').
DO IF (CHAR.INDEX(LTRIM(Position),'R')=1).
COMPUTE Position2=REPLACE(Position2,'L','').
else if  (CHAR.INDEX(LTRIM(Position),'L')=1).
COMPUTE Position2=REPLACE(Position2,'R','').
END IF.
END IF.

COMPUTE Position2=REPLACE(Position2,'  ',' ').
COMPUTE Position2=REPLACE(Position2,'/',' ').
COMPUTE Position2=REPLACE(Position2,':','').
COMPUTE Position2=REPLACE(Position2,'1230','1').
COMPUTE Position2=REPLACE(Position2,'330','4').
COMPUTE Position2=REPLACE(Position2,'630','7').
COMPUTE Position2=REPLACE(Position2,'930','10').
COMPUTE Position2=REPLACE(Position2,'30','').
COMPUTE Position2=REPLACE(Position2,'12-1','1').
COMPUTE Position2=REPLACE(Position2,'3-4','4').
COMPUTE Position2=REPLACE(Position2,'9-10','10').
COMPUTE Position2=REPLACE(Position2,'9-12','10').

COMPUTE Position2=REPLACE(Position2,'L upper outer','L 1').
COMPUTE Position2=REPLACE(Position2,'L upper inner','L 11').
COMPUTE Position2=REPLACE(Position2,'R upper outer','R 11').
COMPUTE Position2=REPLACE(Position2,'R upper inner','R 1').

COMPUTE Position2=REPLACE(Position2,'L upper','L 11,L 1').
COMPUTE Position2=REPLACE(Position2,'R upper','R 11,R 1').

COMPUTE Position2=REPLACE(Position2,'L lower outer','L 4').
COMPUTE Position2=REPLACE(Position2,'L lower inner','L 7').
COMPUTE Position2=REPLACE(Position2,'R lower outer','R 7').
COMPUTE Position2=REPLACE(Position2,'R lower inner','R 4').


COMPUTE Position2=REPLACE(Position2,'L lower','L 4,L 7').
COMPUTE Position2=REPLACE(Position2,'L subareolar','L 4,L 7').
COMPUTE Position2=REPLACE(Position2,'R lower','R 4,R 7').
COMPUTE Position2=REPLACE(Position2,'R subareolar','R 4,R 7').


*replace big(2digit) hours first. use ^UO_ to check the result easier and to have end delimiter.
COMPUTE Position2=REPLACE(Position2,'R 10','^UO_').
COMPUTE Position2=REPLACE(Position2,'R 11','^UO_').
COMPUTE Position2=REPLACE(Position2,'R 12','^UO_|^UI_').

COMPUTE Position2=REPLACE(Position2,'L 10','^UI_').
COMPUTE Position2=REPLACE(Position2,'L 11','^UI_').
COMPUTE Position2=REPLACE(Position2,'L 12','^UI_|^UO_').

*replace short(1digit) hours.
COMPUTE Position2=REPLACE(Position2,'R 1','^UI_').
COMPUTE Position2=REPLACE(Position2,'R 2','^UI_').
COMPUTE Position2=REPLACE(Position2,'R 3','^UI_|^LI_').
COMPUTE Position2=REPLACE(Position2,'R 4','^LI_').
COMPUTE Position2=REPLACE(Position2,'R 5','^LI_').
COMPUTE Position2=REPLACE(Position2,'R 6','^LI_|^LO_').
COMPUTE Position2=REPLACE(Position2,'R 7','^LO_').
COMPUTE Position2=REPLACE(Position2,'R 8','^LO_').
COMPUTE Position2=REPLACE(Position2,'R 9','^LO_|^UO_').

COMPUTE Position2=REPLACE(Position2,'L 1','^UO_').
COMPUTE Position2=REPLACE(Position2,'L 2','^UO_').
COMPUTE Position2=REPLACE(Position2,'L 3','^UO_|^LO_').
COMPUTE Position2=REPLACE(Position2,'L 4','^LO_').
COMPUTE Position2=REPLACE(Position2,'L 5','^LO_').
COMPUTE Position2=REPLACE(Position2,'L 6','^LO_|^LI_').
COMPUTE Position2=REPLACE(Position2,'L 7','^LI_').
COMPUTE Position2=REPLACE(Position2,'L 8','^LI_').
COMPUTE Position2=REPLACE(Position2,'L 9','^LI_|^UI_').


EXECUTE.




STRING pos3(A20).
loop #pos =1 to char.length(Position2).
if char.index(char.substr(Position2,#pos,1),'qwertyuiopasdfghjklzxcvbnm ',1) > 0 pos3 = concat(pos3,char.substr(Position2,#pos,1)).
end loop.
exe.

STRING pos4(A20).
compute pos4=Position2.
loop #pos =1 to char.length(Position2).
if char.index(char.substr(Position2,#pos,1),'-0123456789qwertyuiopasdfghjklzxcvbnm',1) > 0 pos4 = REPLACE(pos4,char.substr(Position2,#pos,1),'').
end loop.

COMPUTE pos4=REPLACE(pos4,',','|').
COMPUTE pos4=REPLACE(pos4,' ','').
COMPUTE pos4=LTRIM(RTRIM(pos4)).



*compute RV.location.
*44497848:Lower-inner quadrant of breast,44497850:Lower-outer quadrant of breast
44497847:Upper-inner quadrant of breast,44497849:Upper-outer quadrant of breast.

DO IF (CHAR.INDEX(pos4,'UO') > 0).
COMPUTE RV.location=CONCAT(RV.location,'|44497849').
END IF.
DO IF (CHAR.INDEX(pos4,'UI') > 0).
COMPUTE RV.location = CONCAT(RV.location,'|44497847').
END IF.
DO IF (CHAR.INDEX(pos4,'LO') > 0).
COMPUTE RV.location = CONCAT(RV.location,'|44497850').
END IF.
DO IF (CHAR.INDEX(pos4,'LI') > 0).
COMPUTE RV.location = CONCAT(RV.location,'|44497848').
END IF.
COMPUTE RV.location=REPLACE(RV.location,'763013|','').
EXECUTE.

*add to location LEFT OR RIGHT.
DO IF (TumorLocation='L').
COMPUTE RV.location = CONCAT('4197399|',RV.location).
ELSE IF (TumorLocation='R').
COMPUTE RV.location = CONCAT('4248990|',RV.location).
else if (TumorLocation='').
DO IF (CHAR.INDEX(LTRIM(Position),'R')=1).
COMPUTE RV.location = CONCAT('4248990|',RV.location).
else if  (CHAR.INDEX(LTRIM(Position),'L')=1).
COMPUTE RV.location = CONCAT('4197399|',RV.location).
END IF.
END IF.
COMPUTE RV.location=REPLACE(RV.location,'|763013','').
EXECUTE.



DELETE VARIABLES PositionBACK Position2 pos3 pos4.
EXECUTE.
