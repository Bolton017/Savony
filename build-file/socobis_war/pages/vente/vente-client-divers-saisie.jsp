<%--
    Document   : client-saisie.php
    Created on : 22 mars 2024, 14:50:09
    Author     : SAFIDY
--%>


<%@page import="client.Client"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="mg.cnaps.compta.ConstanteCompta" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "client.Client",
                nomtable = "CLIENT",
                apres = "client/client-fiche.jsp",
                titre = "Saisie d&#39;un nouveau client";


        Client  client = new Client();
        client.setNomTable("CLIENT");
        PageInsert pi = new PageInsert(client, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("nom").setLibelle("Nom");
        pi.getFormu().getChamp("telephone").setLibelle("T&eacute;l&eacute;phone");
        pi.getFormu().getChamp("mail").setVisible(false);
        pi.getFormu().getChamp("adresse").setVisible(false);
        pi.getFormu().getChamp("datecarte").setVisible(false);
        pi.getFormu().getChamp("telfixe").setVisible(false);
        pi.getFormu().getChamp("compte").setVisible(false);
        pi.getFormu().getChamp("compte").setDefaut(ConstanteCompta.compte_client);
        pi.getFormu().getChamp("compteauxiliaire").setVisible(false);
        //pi.getFormu().getChamp("compte").setPageAppelComplete("mg.cnaps.compta.ComptaCompte", "compte", "COMPTA_COMPTE");
        pi.getFormu().getChamp("remarque").setVisible(false);
        pi.getFormu().getChamp("echeance").setVisible(false);
        pi.getFormu().getChamp("codeclient").setVisible(false);
        pi.getFormu().getChamp("idzoneclient").setVisible(false);
        pi.getFormu().getChamp("CIN").setVisible(false);
        pi.getFormu().getChamp("delai").setVisible(false);
        pi.getFormu().getChamp("estActif").setDefaut("1");
        pi.getFormu().getChamp("estActif").setVisible(false);
        pi.getFormu().getChamp("idPoint").setVisible(false);

        pi.getFormu().getChamp("idTypeClient").setVisible(false);
        pi.getFormu().getChamp("idTypeClient").setDefaut("TYPE009");
        pi.getFormu().getChamp("idprovince").setVisible(false);
        pi.getFormu().getChamp("idtarification").setVisible(false);
        pi.getFormu().getChamp("idtarification").setDefaut("TYPE009");
        pi.getFormu().getChamp("idModePaiement").setVisible(false);
        pi.getFormu().getChamp("nif").setVisible(false);
        pi.getFormu().getChamp("stat").setVisible(false);
        pi.getFormu().getChamp("carte").setVisible(false);
        pi.getFormu().getChamp("taxe").setVisible(false);

        if(request.getParameter("acte")!=null && request.getParameter("acte").compareToIgnoreCase("update")==0){
            titre = "Modifier client";
            pi.getFormu().getChamp("compte").setVisible(false);
            pi.getFormu().getChamp("id").setVisible(false);
        }

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
