<%-- 
    Document   : regularisation-fiche
    Created on : 4 janv. 2022, 23:41:49
    Author     : Lucas
--%>

<%@ page import="affichage.PageConsulte" %>
<%@ page import="facture.tr.Escompte" %>
<%
    String lien = (String) session.getValue("lien"),
           titre = "Fiche Escompte",
           mapping = "facture.tr.Escompte",
           apres = "facture/escompte-fiche.jsp";
    try {
        Escompte escompte = new Escompte();
        escompte.setNomTable("escompte_lib");
        PageConsulte pc = new PageConsulte(escompte, request, (user.UserEJB) session.getValue("u"));
        pc.getChampByName("id").setVisible(false);
        pc.getChampByName("frais").setLibelle("Frais");
        pc.getChampByName("tiers").setLibelle("Tiers");
        pc.getChampByName("banque").setLibelle("Banque");
        pc.getChampByName("daty").setLibelle("Date");
        pc.setTitre(titre);
        escompte = (Escompte) pc.getBase();
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
                
                <div class="box-footer">
                    <a class="btn btn-success"  href="<%=lien + "?but=apresTarif.jsp&acte=valider&classe="+mapping+"&bute="+apres+"&id=" + escompte.getId() %>"  style="margin-right: 10px">Viser</a>
                </div>
                
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
