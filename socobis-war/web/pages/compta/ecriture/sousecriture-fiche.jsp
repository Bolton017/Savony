<%-- 
    Document   : page-fiche-simple
    Created on : 9 mars 2023, 10:08:42
    Author     : BICI
--%>

<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.LinkedHashMap" %>

<%
    try{
    ComptaSousEcritureLib compta = new ComptaSousEcritureLib();
    compta.setNomTable("COMPTA_SOUSECRITURE_LIB");
    PageConsulte pc = new PageConsulte(compta, request, (user.UserEJB) session.getValue("u"));
    String id=pc.getBase().getTuppleID();
    ComptaSousEcritureLib rep=(ComptaSousEcritureLib)pc.getBase();
    pc.getChampByName("idjournal").setVisible(false);
    pc.getChampByName("origine").setVisible(false);
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("datecomptable").setLibelle("Date Comptable");
    pc.getChampByName("idMere").setLibelle("M&egrave;re");
    pc.getChampByName("id").setLibelle("ID");
    pc.setTitre("Fiche Ecriture");
    String lien = (String) session.getValue("lien");
    String pageModif = "update/update-simple.jsp";
    String classe = "mg.cnaps.compta.ComptaSousEcritureLib";
    pc.getChampByName("idMere").setLien(lien+"?but=compta/ecriture/ecriture-fiche.jsp", "id=");

    LinkedHashMap<String, String[]> rubrique = new LinkedHashMap<>();
    rubrique.put("Information g&eacute;n&eacute;rale", new String[]{"numero",
            "journal",
            "ecriture",
            "daty",
            "datecomptable",
            "exercice",
            "remarque",
            "etat",
            "idMere",
            "horsExercice",
            "od",
            "libellePiece",
            "folio",});
    rubrique.put("Imputation comptable", new String[]{"compte",
            "credit",
            "debit",
            "compte_aux",
            "compteauxiliaire",
            "compte_auxlib",
            "lettrage",
            "lettre",
            "analytique",});
    pc.setRubrique(rubrique);


%>
<div class="content-wrapper">
    <section class="content-header">
        <h1 class="box-title"><a href=<%= lien + "?but=compta/ecriture/sousecriture-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>           
    </section>
        <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>
                        <div class="box-footer">
                            <% if (rep.getEtat() == ConstanteEtat.getEtatCreer()) {%>
                                <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute=compta/ecriture/sousecriture-fiche.jsp&classe="+classe %>">
                                    <button class="btn btn-primary pull-right">Valider</button>
                                </a>
                                <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=compta/ecriture/sousecriture-liste.jsp&classe="+classe %>">
                                    <button class="btn btn-warning pull-left">Supprimer</button>
                                </a>
                                <% } %>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
} %>


