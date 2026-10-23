
<%@page import="annexe.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try {
        UserEJB u = (user.UserEJB) session.getValue("u");
        EquivalenceLib objet = new EquivalenceLib();
        objet.setNomTable("EQUIVALENCECARTONLIB");
        PageConsulte pc = new PageConsulte(objet, request, u);
        pc.setTitre("Fiche Equivalence en carton");
        pc.getBase();
        String lien = (String) session.getValue("lien");
        String id = pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("idCartonLib").setLibelle("Carton");
        pc.getChampByName("idPetrisLib").setLibelle("P&eacute;tris");
        pc.getChampByName("nbcarton").setLibelle("Nombre de carton");
        pc.getChampByName("idPetris").setLibelle("ID P&eacute;tris");
        pc.getChampByName("idCarton").setLibelle("ID Carton");
        pc.getChampByName("idPetris").setLien(lien+"?but=produits/as-ingredients-fiche.jsp", "id=");
        pc.getChampByName("idCarton").setLien(lien+"?but=produits/as-ingredients-fiche.jsp", "id=");
        pc.setModalOnClick(true);
        String pageModif = "annexe/equivalence/equivalence-carton-saisie.jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=annexe/equivalence/equivalence-carton-liste.jsp"%> ><i class="fa fa-arrow-circle-left"> </i> </a><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer d-flex flex-wrap align-items-center gap-2">
                            <div class="d-flex flex-wrap gap-2">
                                <a class="btn btn-secondary" href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>">Modifier</a>
                            </div>
                        <div class="box-footer"></div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%=pc.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
    e.printStackTrace();
}%>

