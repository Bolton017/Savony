<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="maintenance.configuration.AttributionElementLib" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    AttributionElementLib categorie = new AttributionElementLib();
    PageConsulte pc = new PageConsulte(categorie, request, u);
    pc.setTitre("Fiche d'une attribution d'&eacute;l&eacute;ment");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idIngredientMaintenanceLib").setLibelle("&Eacute;l&eacute;ment");
    pc.getChampByName("idPersonnelLib").setLibelle("Attribut&eacute; &agrave;");
    pc.getChampByName("typeAttributionLib").setLibelle("&Eacute;tat de l'attribution");
    pc.getChampByName("daty").setLibelle("Date du mouvement");
    pc.getChampByName("qte").setLibelle("Quantit&eacute;");
    pc.getChampByName("qualiteObjetMaintenanceLib").setLibelle("Qualit&eacute; de l'&eacute;l&eacute;ment");
//    pc.getChampByName("idPersonnelLib").setLibelle("Personnel");
    pc.getChampByName("idPersonnel").setVisible(false);
    pc.getChampByName("typeAttribution").setVisible(false);
    pc.getChampByName("etatElement").setVisible(false);
    pc.getChampByName("idIngredientMaintenance").setVisible(false);
    pc.getChampByName("etatLib").setVisible(false);
    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/ressources/outils/attribution/attribution-saisie.jsp&acte=update";
    String classe = "maintenance.configuration.AttributionElement";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/ressources/outils/attribution/attribution-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/ressources/outils/attribution/attribution-liste.jsp&classe="+classe %>">Supprimer</a>
                            <a  class="btn btn-primary pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute=maintenance/ressources/outils/attribution/attribution-fiche.jsp&classe="+classe %>">Valider</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

