<%--
    Document   : pertegain-mvtcaisse-saisie
    Created on : 30 juil. 2024, 16:07:17
    Author     : bruel
--%>

<%@page import="pertegain.PerteGainImprevueLib"%>
<%@page import="utils.ConstanteStation"%>
<%@page import="caisse.Caisse"%>
<%@page import="pertegain.PerteGainImprevue"%>
<%@page import="caisse.MvtCaisse"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.ModePaiement" %>
<%
    try{
        MvtCaisse a = new MvtCaisse();
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));



        pi.setLien((String) session.getValue("lien"));
        String id =request.getParameter("id");
        String montant =request.getParameter("montant");
        String perteougain =request.getParameter("perteougain");
        Liste[] liste = new Liste[1];
        PerteGainImprevueLib pertegainimprevue = PerteGainImprevueLib.getById(id);
        if(pertegainimprevue.getEtat()<ConstanteEtat.getEtatValider()) throw new Exception("Perte ou Gain doit etre valider avant de generer un mouvement de caisse!");
        Caisse type = new Caisse();
        type.setIdPoint(ConstanteStation.getFichierCentre());
        type.setNomTable("CAISSE");
        liste[0] = new Liste("idCaisse",type,"val","id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("IdVenteDetail").setVisible(false);
        pi.getFormu().getChamp("IdVirement").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOp").setVisible(false);
        pi.getFormu().getChamp("taux").setVisible(false);
        pi.getFormu().getChamp("taux").setDefaut("1");
        pi.getFormu().getChamp("iddevise").setVisible(false);
        pi.getFormu().getChamp("iddevise").setDefaut("AR");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");
        pi.getFormu().getChamp("idtraite").setLibelle("ID Traite");
        pi.getFormu().getChamp("etatversement").setLibelle("&Eacute;tat de versement");
        pi.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("idmvtcaissemere").setLibelle("Mouvement de caisse m&egrave;re");
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("datycomptabilisation").setLibelle("Date de comptabilisation");

        pi.getFormu().getChamp("idOrigine").setLibelle("Perte/Gain Imprevue");
        pi.getFormu().getChamp("idOrigine").setAutre("readonly");
        pi.getFormu().getChamp("idCaisse").setLibelle("Caisse");
        pi.getFormu().getChamp("idtiers").setDefaut(pertegainimprevue.getTiers());
        pi.getFormu().getChamp("idtiers").setPageAppelComplete("client.Client","id","Client");
        pi.getFormu().getChamp("idtiers").setPageAppelInsert("client/client-saisie.jsp","idtiers;idtierslibelle","id;nom");

        if(pertegainimprevue.getGain()>0){
            pi.getFormu().getChamp("debit").setVisible(false);
            pi.getFormu().getChamp("credit").setLibelle("Montant a payer ");
            pi.getFormu().getChamp("credit").setDefaut(montant);
        } else if (pertegainimprevue.getPerte()>0){
            pi.getFormu().getChamp("credit").setVisible(false);
            pi.getFormu().getChamp("debit").setLibelle("Montant a payer ");
            pi.getFormu().getChamp("debit").setDefaut(montant);
        }
        pi.getFormu().getChamp("designation").setDefaut(pertegainimprevue.getDesignation());
        pi.getFormu().getChamp("idOrigine").setDefaut(id);
        //Variables de navigation
        String classe = "caisse.MvtCaisse";
        String butApresPost = "caisse/mvt/mvtCaisse-fiche.jsp";
        String nomTable = "MOUVEMENTCAISSE";
        //Generer les affichages
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Encaissement Perte ou Gain Impr&eacute;vue </h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
}
catch(Exception e){
    e.printStackTrace();
%>
<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
    }
%>

