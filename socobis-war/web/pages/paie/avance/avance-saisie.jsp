<%-- 
    Document   : avance-saisie
    Created on : 20 Sep. 2022, 15:44:38
    Author     : Sambatra Rakotondrainibe
--%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.Liste"%> 
<%@page import="bean.TypeObjet"%>
<%@ page import="paie.avance.Avance" %>
<%
    try{
    String lien = (String) session.getValue("lien");
    UserEJB u = (user.UserEJB) session.getValue("u");
    Avance av= new Avance();
    av.setNomTable("avance");
    PageInsert pi = new PageInsert(av, request, u);
    pi.setLien(lien);


    String apres = "paie/avance/avance-fiche.jsp";
    Liste[] listes = new Liste[1];
    TypeObjet tp = new TypeObjet();
    tp.setNomTable("typeavance");
    listes[0] = new Liste("idtypeavance", tp, "val", "id");
    pi.getFormu().changerEnChamp(listes);

    pi.setTitre(" Saisie D'une Avance");
    pi.getFormu().getChamp("daty").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
        // pi.getFormu().getChamp("idpersonnel").setPageAppel("choix/logPersonnelChoix.jsp");
        //affichage.Champ.setPageAppelComplete(pi.getFormu().getChampMulitple("idpersonnel").getListeChamp(),"personnel.Personnel", "id", "personnel", "nom","id");
        pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2");
        pi.getFormu().getChamp("dateAvance").setDefaut(Utilitaire.dateDuJour());

        pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("dateAvance").setLibelle("Date De l'avance");
        pi.getFormu().getChamp("nbremboursement").setLibelle("Nombre de remboursement");
        pi.getFormu().getChamp("nbremboursement").setDefaut("1");
        pi.getFormu().getChamp("idtypeavance").setLibelle("Type");
        pi.getFormu().getChamp("montant").setLibelle("Montant(Ar)");
        pi.getFormu().getChamp("interet").setLibelle("Int&eacute;r&ecirc;t (%)");
        pi.getFormu().getChamp("interet").setDefaut("1");
        
        pi.getFormu().getChamp("remarque").setVisible(false);
    String classe = "paie.avance.Avance";
    
    String[] ordre = {"dateAvance","idtypeavance","idpersonnel","nbremboursement","daty","etat","remarque"};
    pi.getFormu().setOrdre(ordre);
    
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>
<script>

</script>
<div class="content-wrapper">
    <h1> <%=pi.getTitre()%></h1>
    
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=av.getNomTable()%>" id="<%=av.getNomTable()%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="daty" type="hidden" id="daty" value="<%=Utilitaire.dateDuJour()%>">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classe%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=av.getNomTable()%>">


    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>
