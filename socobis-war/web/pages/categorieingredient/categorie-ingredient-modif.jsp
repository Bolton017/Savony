<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 03/04/2025
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>
<%@ page import="produits.CategorieIngredient" %>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    CategorieIngredient t = new CategorieIngredient();
    String  mapping = "produits.CategorieIngredient",
            nomtable = "CATEGORIEINGREDIENT",
            apres = "categorieingredient/categorie-ingredient-fiche.jsp",
            titre = "Insertion nouvelle cat&eacutegorie d'ingr&eacute;dient";
    PageUpdate pu = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pu.setLien((String) session.getValue("lien"));
    pu.setTitre(titre);
    pu.getFormu().getChamp("id").setAutre("readonly");
    pu.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pu.getFormu().getChamp("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String id=pu.getBase().getTuppleID();
    pu.preparerDataFormu();
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but="+apres+"&id="+id%>> <i class="fa fa-arrow-circle-left"></i></a><%=pu.getTitre()%></h1>
                    </div>
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
                        <%
                            out.println(pu.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-11">
                                <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                            </div>
                            <br><br>
                        </div>
                        <input name="acte" type="hidden" id="acte" value="update">
                        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
                        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
                        <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%out.print(request.getParameter("id"));%>" >
                        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
