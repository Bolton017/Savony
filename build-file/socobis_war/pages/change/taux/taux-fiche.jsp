<%@page import="change.*" %>
<%@page import="affichage.*" %>
<%
    TauxDeChange taux = new TauxDeChange();
    PageConsulte pc = new PageConsulte( taux, request, (user.UserEJB) session.getValue("u") );
    String tauxId = pc.getBase().getTuppleID();
    String lien = (String) session.getValue("lien");
    pc.setLien(lien);
    pc.setTitre("Fiche de Taux");
    pc.getChampByName("id").setLibelle("Id Taux");
    pc.getChampByName("idDevise").setLibelle("Devise");
    pc.getChampByName("daty").setLibelle("Date");
    String pageModif = "change/taux/taux-saisie.jsp";
    String classe = "change.TauxDeChange";

%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=change/taux/taux-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + tauxId +"&acte=update"%>" style="margin-right: 10px">
                                    Modifier
                                </a>                           
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>