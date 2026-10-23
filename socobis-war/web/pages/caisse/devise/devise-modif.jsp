
<%@page import="caisse.Devise"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Devise devise = new Devise();
      String  mapping = "caisse.Devise",
            nomtable = "devise",
            apres = "caisse/devise/devise-fiche.jsp",
            titre = "Modification Devise";
    PageUpdate pu = new PageUpdate(devise, request, (user.UserEJB) session.getValue("u"));
    pu.setLien((String) session.getValue("lien"));
    pu.setTitre(titre);
    pu.getFormu().getChamp("id").setAutre("readonly");
    pu.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pu.getFormu().getChamp("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String id=pu.getBase().getTuppleID();
    pu.preparerDataFormu();
%>
<style>
    .col-md-12.cardradius.input-container {
        border: none;
        border-top: none !important;
        padding: 0;
        margin-bottom: 20px;
    }
    .col-md-12.mb-5.import-input {
        display: none;
    }
    .box-footer{
        border-top: none;
    }
</style>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=caisse/devise/devise-fiche.jsp&id="+id%> <i class="fa fa-arrow-circle-left"></i></a><%=pu.getTitre()%></h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
                        <%
                            out.println(pu.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-12">
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
