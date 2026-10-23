<%@page import="affichage.*"%>
<%@page import="user.*"%>
<%@ page import="caisse.ClotureCaisseCPL" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    try{
        UserEJB user = (UserEJB) session.getValue("u");
        ClotureCaisseCPL mapping = new ClotureCaisseCPL();
        mapping.setNomTable("CLOTURECAISSE_CPL");
        mapping.setId(request.getParameter("id"));

        PageConsulte pc = new PageConsulte( mapping, request, user );
        String id=pc.getBase().getTuppleID();

        pc.setTitre("Fiche d'une cl&ocirc;ture de caisse");
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("daty").setLibelle("Date");
//        pc.getChampByName("montantTheorique").setLibelle("Montant th&eacute;orique");
        pc.getChampByName("idPointLib").setVisible(false);
        pc.getChampByName("etat").setLibelle("&Eacute;tat");

        pc.getChampByName("idPoint").setVisible(false);
        pc.getChampByName("etatLib").setVisible(false);

        String pageActuel = "cloturecaisse/cloturecaisse-fiche.jsp";
        String lien = (String) session.getValue("lien");
        String classe = "caisse.ClotureCaisse";
        mapping = (ClotureCaisseCPL) pc.getBase();

        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("cloture-details", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "cloture-details";
        }
        tab = "inc/" + tab + ".jsp";

%>

<div class="content-wrapper">
    <h1 class="box-title"><%=pc.getTitre()%></h1>
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
                            <% if (mapping.getEtat() == 1) { %>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=cloturecaisse/cloturecaisse-fiche.jsp&classe=" + classe %> ">Viser</a>

                            <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=cloturecaisse/cloturecaisse-saisie.jsp&acte=update&id=" + request.getParameter("id") %>" style="margin-right: 10px">Modifier</a>
                            <% } else { %>

                            <% } %>
                            <a class="btn btn-tertiary pull-left"href="${pageContext.request.contextPath}/ExportPDF?action=cloturecaisse&id=<%= request.getParameter("id") %>&point=<%= mapping.getIdPoint() %>&daty=<%= mapping.getDaty() %>">Imprimer</a>
                        </div>
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
                    <li class="<%=map.get("cloture-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=avoirfc-details">D&eacute;tails</a></li>

                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>