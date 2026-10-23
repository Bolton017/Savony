
<%@page import="paie.elementpaie.PaiePersonnelElementpaie"%>
<%@page import="affichage.Liste"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="affichage.PageRecherche"%>

<% 
    try{
    PaiePersonnelElementpaie dr = new PaiePersonnelElementpaie();
    String nomTable = "PAIE_PERSONNEL_ELEMENTPAIE_LIB";

    if (request.getParameter("table") != null && request.getParameter("table").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("table");
    }
    dr.setNomTable(nomTable);

    String listeCrt[] = {"id", "code_rubrique","idcategorie_qualification","idfonction", "remarque", "moisregularisation","anneeregularisation","date_debut","date_fin","idpersonnel"};
    String listeInt[] = {""};
    String libEntete[] = {"id","idpersonnel", "code_rubrique","idcategorie_qualification", "idfonction", "remarque", "moisregularisation","anneeregularisation","date_debut","date_fin","pourcentage","gain","retenue"};
    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("code_rubrique").setLibelle("Rubrique");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    pr.getFormu().getChamp("moisregularisation").setLibelle("Mois");
    pr.getFormu().getChamp("anneeregularisation").setLibelle("Ann&eacute;e");
    pr.getFormu().getChamp("date_debut").setLibelle("Date d&eacute;but");
    pr.getFormu().getChamp("date_fin").setLibelle("Date fin");
    pr.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pr.getFormu().getChamp("idcategorie_qualification").setLibelle("Cat&eacute;gorie qualification");
    pr.getFormu().getChamp("idfonction").setLibelle("Fonction");
   

//    pr.getFormu().getChamp("dateapplication1").setLibelle("Date d'application min");
//    pr.getFormu().getChamp("dateapplication2").setLibelle("Date d'application max");
//    pr.getFormu().getChamp("idlogpers").setLibelle("Personnel");
//    pr.getFormu().getChamp("idtypedebauche").setLibelle("Cause de d&eacute;part");
    pr.setApres("paie/fonction/paiepersonnelelementpaie-listemu.jsp");
        
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste &eacute;l&eacute;ment paie</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/fonction/paiepersonnelelementpaie-listemu.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <%  String lienTableau[] = {pr.getLien() + "?but=paie/fonction/paiepersonnelelementpaie-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        
        <form action="<%=pr.getLien()%>?but=visa-multiple2.jsp" method="post" name="incident" id="incident">
            <input type="hidden" name="bute" value="paie/fonction/paiepersonnelelementpaie-listemu.jsp"/>
            <input type="hidden" name="classe" value="mg.fer.paie.PaiePersonnelElementpaie"/>
            <input type="hidden" name="acte" value="viser"/>
        <%
            String libEnteteAffiche[] = {"id","Personnel", "rubrique","Cat&eacute;gorie qualification","Fonction", "remarque", "mois r&eacute;gularisation","ann&eacute;e r&eacute;gularisation","date d&eacute;but","date fin","Pourcentage","gain","retenue"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            
            pr.getTableau().setNameActe("viser");
            pr.getTableau().setNameBoutton("Viser");
            out.println(pr.getTableau().getHtmlWithCheckbox());
           %>
        </form>
        
    </section>
</div>
<% } catch(Exception e) { e.printStackTrace();}%>
