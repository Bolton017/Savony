<%@ page import="user.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*"%>
<%@page import="compteur.*"%>
<%@ page import="magasin.Magasin" %>
<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (UserEJB) session.getAttribute("u");
        Compteur compteur = new Compteur();
        compteur.setNomTable("COMPTEUR");
        PageInsert pi = new PageInsert(compteur, request, u);
        pi.setLien((String) session.getValue("lien"));

        affichage.Liste[] liste = new affichage.Liste[2];

        TypeObjet machine = new TypeObjet();
        machine.setNomTable("MACHINE");
        liste[0] = new Liste("idMachine", machine, "val", "id");

        Magasin magasin = new Magasin();
        magasin.setNomTable("MAGASIN2");
        liste[1] = new Liste("idOrigine", magasin, "val", "id");

        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("daty").setLibelle("Date de saisie");
        pi.getFormu().getChamp("idMachine").setLibelle("Machine");
        pi.getFormu().getChamp("nombre").setLibelle("Compteur actuel");
        pi.getFormu().getChamp("heure").setLibelle("Heure");
        pi.getFormu().getChamp("heure").setDefaut(utilitaire.Utilitaire.heureCouranteHM());
        pi.getFormu().getChamp("idFabrication").setLibelle("ID Fabrication");
        pi.getFormu().getChamp("idOrigine").setLibelle("Cuve d'origine");
        pi.getFormu().getChamp("debut").setLibelle("D&eacute;but");
        pi.getFormu().getChamp("idFabrication").setPageAppelComplete("fabrication.Fabrication","id","FABRICATION");
        pi.getFormu().getChamp("etat").setVisible(false);
        String[] formOrder={"daty","idMachine","nombre","heure","idFabrication"};
        pi.getFormu().setOrdre(formOrder);
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1 class="box-title">Saisie d'un Compteur</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="appro" id="appro" >
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="acte" value="insert">
        <input name="bute" type="hidden" id="bute" value="compteur/compteur-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="compteur.Compteur">
    </form>
</div>

<%} catch(Exception ex){
    ex.printStackTrace();
}%>