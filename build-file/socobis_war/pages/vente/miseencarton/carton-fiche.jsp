<%@ page import="user.UserEJB" %>
<%@ page import="vente.Carton" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="affichage.PageConsulte" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>
<%
    String lien = (String) session.getValue("lien");
    Carton c = new Carton();
    c.setNomTable("carton");
    PageConsulte pc = new PageConsulte(c, request, u);
    pc.setTitre("Fiche mise en carton");
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("dateCreation").setLibelle("date");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idBc").setLibelle("Bon de commande");
    pc.getChampByName("idBc").setLien(lien+"?but=vente/bondecommande/bondecommande-fiche.jsp", "id=");
    pc.getChampByName("idBL").setLibelle("Bon de livraison");
    pc.getChampByName("idBL").setLien(lien+"?but=vente/bondelivraison-client/bondelivraison-client-fiche.jsp", "id=");

    pc.getChampByName("etat").setLibelle("Etat");

    String pageModif = "vente/miseencarton/carton-modif.jsp";
    String pageActuel = "vente/miseencarton/carton-fiche.jsp";
    String classe = "vente.Carton";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/carton-details", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/carton-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    Carton bc = (Carton) pc.getBase();
    int etat = bc.getEtat();
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=vente/miseencarton/carton-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <%
                                if( etat < 11 ){ %>
                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuel+"&classe="+classe %>" style="margin-right: 10px"><button class="btn btn-danger">Supprimer</button></a>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=vente.Carton&nomtable=carton"%> " style="margin-right: 10px">Viser</a>

                            <%    }
                            %>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
</div>
        <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/carton-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/carton-details">Details Carton </a></li>                
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idbc" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
    </div>