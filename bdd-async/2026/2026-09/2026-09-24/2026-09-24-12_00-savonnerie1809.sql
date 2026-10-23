UPDATE MENUDYNAMIQUE SET LIBELLE='Emplacement', ID_PERE='MNDN00000002111' WHERE ID='MDLOCO0000056';

UPDATE MENUDYNAMIQUE x
	SET x.HREF='module.jsp?but=stock/etatstock/etatstock-liste-emplacement.jsp',x.LIBELLE='État de stock par emplacement'
	WHERE x.ID='MNDNST0002706171';
