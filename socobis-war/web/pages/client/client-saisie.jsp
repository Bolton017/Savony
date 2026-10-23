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
    pi.getFormu().getChamp("mail").setLibelle("Adresse e-mail");
    pi.getFormu().getChamp("adresse").setLibelle("Adresse");
        pi.getFormu().getChamp("datecarte").setLibelle("Date d ' &eacute;xpiration de la carte");
        pi.getFormu().getChamp("telfixe").setLibelle("T&eacute;l&eacute;phone Fixe");
    pi.getFormu().getChamp("compte").setLibelle("Compte G&eacute;n&eacute;ral");
    pi.getFormu().getChamp("compte").setDefaut(ConstanteCompta.compte_client);
    pi.getFormu().getChamp("compteauxiliaire").setLibelle("Compte Auxiliaire");
    //pi.getFormu().getChamp("compte").setPageAppelComplete("mg.cnaps.compta.ComptaCompte", "compte", "COMPTA_COMPTE");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("echeance").setLibelle("Ech&eacute;ance de paiement");
        pi.getFormu().getChamp("codeclient").setLibelle("Code Client");
    pi.getFormu().getChamp("idzoneclient").setLibelle("Zone client");
    pi.getFormu().getChamp("idzoneclient").setPageAppelComplete("bean.TypeObjet", "id", "ZONECLIENT");
        pi.getFormu().getChamp("CIN").setLibelle("CIN");
        pi.getFormu().getChamp("delai").setLibelle("D&eacute;lai de validit&eacute; du prix (jours)");
        pi.getFormu().getChamp("estActif").setDefaut("1");
        pi.getFormu().getChamp("estActif").setVisible(false);
        pi.getFormu().getChamp("image").setVisible(false);
    pi.getFormu().getChamp("idPoint").setLibelle("ID Point");
    pi.getFormu().ajouterChampAttacherFichier();



        affichage.Liste[] listes = new affichage.Liste[4];
    TypeObjet typeObjet = new TypeObjet("typeclient");
        TypeObjet prov = new TypeObjet("province");
    listes[0] = new Liste("idTypeClient", typeObjet, "val", "id");
        listes[1] = new Liste("idprovince", prov, "val", "id");
        TypeObjet modele = new TypeObjet("MODEPAIEMENT");
        listes[2] = new Liste("idModePaiement", modele, "val", "id");
    TypeObjet tarif = new TypeObjet("TARIFICATION");
    listes[3] = new Liste("idTarification", tarif, "val", "id");
    pi.getFormu().changerEnChamp(listes);

    pi.getFormu().getChamp("idTypeClient").setLibelle("Tarification");
        pi.getFormu().getChamp("idprovince").setLibelle("Province");
        pi.getFormu().getChamp("idtarification").setLibelle("Type client");
        pi.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");

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
