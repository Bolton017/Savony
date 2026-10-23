<%-- 
    Document   : as-tarifproduits-fiche
    Created on : 1 d�c. 2016, 10:55:21
    Author     : Joe
--%>

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="mg.allosakafo.produits.TarifProduits"%>
<%
    TarifProduits a = new TarifProduits();
    a.setNomTable("as_prixproduit_libelle");
    PageConsulte pc = pc = new PageConsulte(a, request, (user.UserEJB) session.getValue("u"));//ou avec argument liste Libelle si besoin
    
    /*pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("unite").setLibelle("Unit�");
    pc.getChampByName("typearticle").setLibelle("Type");
    pc.getChampByName("groupee").setLibelle("Groupe");
    pc.getChampByName("sousgroupe").setLibelle("Sous groupe");
    */
    pc.setTitre("Consultation tarif produit");
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-tarifproduits-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-left"  href="<%=(String) session.getValue("lien") + "?but=produits/as-tarifproduits-modif.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%out.println(pc.getBasPage());%>
</div>