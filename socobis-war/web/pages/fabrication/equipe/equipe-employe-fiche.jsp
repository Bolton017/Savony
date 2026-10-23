<%@page import="annexe.CategorieLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fabrication.equipe.EquipeEmpCpl" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    EquipeEmpCpl categorie = new EquipeEmpCpl();
    categorie.setNomTable("EQUIPE_EMP_CPL");

    PageConsulte pc = new PageConsulte(categorie, request, u);
    pc.setTitre("Fiche &Eacute;quipe Personnels");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("nomEmploye").setLibelle("Nom employ&eacute;");
    pc.getChampByName("nomEquipe").setLibelle("Nom &eacute;quipe");
    pc.getChampByName("IDEQUIPE").setVisible(false);
    pc.getChampByName("IDEMPLOYE").setVisible(false);


    String lien = (String) session.getValue("lien");
//    String pageModif = "fabrication/equipe/equipe-modif.jsp";
    String pageEquipeEmpCplEmpSaisie = "fabrication/equipe/equipe-employe-saisie.jsp";

    String classe = "fabrication.equipe.EquipeEmpCpl";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=fabrication/equipe/equipe-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=fabrication/equipe/equipe-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

