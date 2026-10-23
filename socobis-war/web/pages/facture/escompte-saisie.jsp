<%-- 
    Document   : escompte-saisie
    Created on : 05 jan. 2023, 10:49:39
    Author     : Lucas
--%>
<%@page import="facture.tr.Escompte"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%  
    
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Escompte escompte = new Escompte();
    PageInsert pi = new PageInsert(escompte, request, (user.UserEJB) session.getValue("u"));
    affichage.Champ[] liste = new affichage.Champ[1];
    TypeObjet o = new TypeObjet();
    o.setNomTable("banque");
    liste[0] = new Liste("banque", o, "VAL", "id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idtraite").setLibelle("Traite");
    pi.getFormu().getChamp("idtraite").setPageAppel("choix/traiteChoix.jsp");
    if(request.getParameter("idTraite")!=null)pi.getFormu().getChamp("idtraite").setDefaut(request.getParameter("idTraite"));
    pi.getFormu().getChamp("idtraite").setAutre("readonly");
    pi.getFormu().getChamp("frais").setLibelle("Frais");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.setLien((String) session.getValue("lien"));
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1>Saisie escompte</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="sig_commune" id="sig_commune" data-parsley-validate>
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="facture/escompte-fiche.jsp">
    <input name="classe" type="hidden" id="classe" value="facture.tr.Escompte">
    <input name="nomtable" type="hidden" id="classe" value="escompte">
    </form>
</div>
<%}catch(Exception e){
    e.printStackTrace();
}%>