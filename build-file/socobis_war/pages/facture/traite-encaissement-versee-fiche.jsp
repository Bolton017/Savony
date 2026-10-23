<%@ page import="affichage.PageConsulte" %>
<%@ page import="facture.tr.MvttIntraCaisse" %>
<%
    String lien = (String) session.getValue("lien"),
           titre = "Fiche Mouvement Intracaisse",
           mapping = "facture.tr.MvttIntraCaisse",
           apres = "facture/traite-encaissement-versee-fiche.jsp";
    try {
        MvttIntraCaisse mvttIntraCaisse = new MvttIntraCaisse();
        mvttIntraCaisse.setNomTable("MVTINTRACAISSETRAITEV");
        PageConsulte pc = new PageConsulte(mvttIntraCaisse, request, (user.UserEJB) session.getValue("u"));
        
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("caissedepart").setVisible(false);
        pc.getChampByName("caissearrivee").setVisible(false);
        pc.getChampByName("modepaiement").setVisible(false);
        pc.getChampByName("etatversementlib").setVisible(false);
        pc.getChampByName("etatversement").setVisible(false);
        pc.getChampByName("idfinaledestination").setVisible(false);
        pc.getChampByName("etatlib").setVisible(false);
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("caissedepartlib").setLibelle("Caisse Depart");
        pc.getChampByName("caissearriveelib").setLibelle("Caisse Arrivee");
        pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
        pc.getChampByName("finaledestinationlib").setLibelle("Destination finale");
        pc.getChampByName("dateecheance").setLibelle("Date Echeance");
        pc.getChampByName("idTraite").setLibelle("Traite");
        pc.setTitre(titre);
        mvttIntraCaisse = (MvttIntraCaisse) pc.getBase();
%>

<style>
    .col-md-center .box-fiche{
        min-width:100%;
    }
</style>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="box" id="fiche">
                <div class="box-title with-border">
                    <h1 class="box-title"><%=pc.getTitre()%></h1>
                </div>
                <div class="box-body">
                    <%out.println(pc.getHtml());%>
                </div>
                
<%--                <div class="box-footer">--%>
<%--                    <a class="btn btn-success"  href="<%=lien + "?but=apresTarif.jsp&acte=valider&classe="+mapping+"&bute="+apres+"&id=" + mvttIntraCaisse.getId() %>"  style="margin-right: 10px">Viser</a>--%>
<%--                    <a class="btn btn-primary"  href="<%=lien + "?but=treso/journalcaisse-saisie.jsp&idmvtcaisse=" + mvttIntraCaisse.getId()+"&idfinaledestination="+ mvttIntraCaisse.getIdfinaledestination()+"&montant="+mvttIntraCaisse.getMontant()+"&idTraite="+mvttIntraCaisse.getIdTraite()%>"  style="margin-right: 10px">Verser</a>--%>
<%--                </div>--%>
                
            </div>
        </div>
    </div>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> 
	alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>
