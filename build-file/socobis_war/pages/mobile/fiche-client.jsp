<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="client.ClientLib" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    ClientLib client = new ClientLib();
    client.setNomTable("CLIENTLIB");

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche Client");
    client = (ClientLib) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("payeur").setLibelle("Magasin");
    pc.getChampByName("nom").setLibelle("Nom propri&eacute;taire");
    pc.getChampByName("telephone").setLibelle("Contact");
    pc.getChampByName("adresse").setLibelle("Localisation");
    pc.getChampByName("idTypeClientLib").setLibelle("Cat&eacute;gorie");

    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("codeclient").setVisible(false);
    pc.getChampByName("mail").setVisible(false);
    pc.getChampByName("datecarte").setVisible(false);
    pc.getChampByName("telfixe").setVisible(false);
    pc.getChampByName("echeance").setVisible(false);
    pc.getChampByName("IdTarificationLib").setVisible(false);
    pc.getChampByName("remarque").setVisible(false);
    pc.getChampByName("compte").setVisible(false);
    pc.getChampByName("compteauxiliaire").setVisible(false);
    pc.getChampByName("idTypeClient").setVisible(false);
    pc.getChampByName("idProvince").setVisible(false);
    pc.getChampByName("provinceLib").setVisible(false);
    pc.getChampByName("idModePaiement").setVisible(false);
    pc.getChampByName("idModePaiementLib").setVisible(false);
    pc.getChampByName("CIN").setVisible(false);
    pc.getChampByName("taxe").setVisible(false);
    pc.getChampByName("Idzoneclient").setVisible(false);
    pc.getChampByName("IdzoneclientLib").setVisible(false);
    pc.getChampByName("delai").setVisible(false);
    pc.getChampByName("nif").setVisible(false);
    pc.getChampByName("carte").setVisible(false);
    pc.getChampByName("stat").setVisible(false);
    pc.getChampByName("image").setVisible(false);

    String[] ordre = {"nom",  "telephone", "adresse", "idTypeClientLib"};

    pc.setOrdre(ordre);
    String lien = (String) session.getValue("lien");
    String classe = "client.Client";
    String pageActuel = "mobile/fiche-client.jsp";
    pc.setDossier("CLIENT");
%>

<div class="content-wrapper">
    <% String titre = "Fiche du client No " + client.getId();%>
    <jsp:include page="/pages/elements/headerMobile.jsp">
        <jsp:param name="titre" value="<%= titre %>"/>
    </jsp:include>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%=pc.getHtmlAvatarImg(classe,"/assets/img/woman.jpg",pageActuel,true)%>
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=mobile/saisie-client.jsp&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
<%--                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("nom").getValeur() %>" style="margin-right: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>--%>
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=client/client-liste.jsp&classe="+classe %>">D&eacute;sactiver</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%}catch (Exception e){
    e.printStackTrace();
}%>
