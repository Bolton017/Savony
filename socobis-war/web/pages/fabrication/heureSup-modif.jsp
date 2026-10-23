<%@page import="fabrication.*"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    HeureSupFabrication t = new HeureSupFabrication();

    String  mapping = "fabrication.HeureSupFabrication",
            nomtable = "heureSupFabrication",
            apres = "fabrication/heureSup-fiche.jsp";


    PageUpdate pu = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pu.setLien((String) session.getValue("lien"));
    pu.setTitre("Modification HS");

    pu.getFormu().getChamp("idRessParFab").setAutre("readonly");
    pu.getFormu().getChamp("id").setVisible(false);
    pu.getFormu().getChamp("idRessParFab").setLibelle("Ressource Fabrication");
    pu.getFormu().getChamp("HD").setLibelle("Heure Dimanche");
    pu.getFormu().getChamp("HS").setLibelle("Heure Suppl&eacute;mentaireDescription");
    pu.getFormu().getChamp("JF").setLibelle("Jour Feri&eacute;");
    pu.getFormu().getChamp("IF").setLibelle("Indemnit&eacute; de fonction");
    pu.getFormu().getChamp("MN").setLibelle("Majoration Nuit");

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
                        <h1 class="box-title"><a href=<%= lien + "?but=fabrication/heureSup-fiche.jsp&id="+id%> <i class="fa fa-arrow-circle-left"></i></a><%=pu.getTitre()%></h1>
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
