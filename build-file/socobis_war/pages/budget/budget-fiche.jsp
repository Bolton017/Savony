<%@page import="prevision.PrevisionCPL"%>
<%@page import="affichage.*"%>
<%@page import="user.*"%>
<%
    try{
        UserEJB user = (UserEJB) session.getValue("u");
    PrevisionCPL prevision = new PrevisionCPL();
    prevision.setNomTable("PREVISION_CPL");
    prevision.setId(request.getParameter("id"));
    PageConsulte consulte = new PageConsulte( prevision, request, user );
    consulte.setTitre("Fiche de Budget");
    consulte.getChampByName("id").setLibelle("Id");
    consulte.getChampByName("designation").setLibelle("D&eacute;signation");
    consulte.getChampByName("idCaisseLib").setLibelle("Caisse");
    consulte.getChampByName("idCaisseLib").setVisible(false);
    consulte.getChampByName("idVenteDetail").setVisible(false);
    consulte.getChampByName("idVirement").setVisible(false);
    consulte.getChampByName("debit").setLibelle("d&eacute;pense");
    consulte.getChampByName("credit").setLibelle("recette");
    consulte.getChampByName("idCaisse").setVisible(false);
    consulte.getChampByName("idOp").setVisible(false);
    consulte.getChampByName("idOrigine").setLibelle("Origine");
    consulte.getChampByName("etat").setVisible(false);
    // consulte.getChampByName("etatLib").setVisible(false);
    consulte.getChampByName("idTiers").setVisible(false);
    consulte.getChampByName("idVenteLib").setLibelle("Vente");
    consulte.getChampByName("idVenteLib").setVisible(false);
    consulte.getChampByName("idDevise").setLibelle("Devise");
    consulte.getChampByName("idDeviseLib").setVisible(false);
    consulte.getChampByName("idOpLib").setLibelle("Op");
    consulte.getChampByName("idOpLib").setVisible(false);
    consulte.getChampByName("idFacture").setVisible(false);
//    consulte.getChampByName("dureeRetard").setVisible(false);
    consulte.getChampByName("idOrigine").setVisible(false);
    consulte.getChampByName("idService").setVisible(false);
    consulte.getChampByName("service").setVisible(false);
//    consulte.getChampByName("dateInitial").setVisible(false);
//    consulte.getChampByName("dureeRetard").setVisible(false);
    consulte.getChampByName("Annee").setLibelle("Ann&eacute;e");
    consulte.getChampByName("idservicelib").setLibelle("D&eacute;partement");
    consulte.getChampByName("daty").setLibelle("Date");
    consulte.getChampByName("moislib").setLibelle("Mois");

    String pageActuel = "budget/budget-fiche.jsp";
    String lien = (String) session.getValue("lien");
    String classe = "budget.Budget";
    prevision = (PrevisionCPL) consulte.getBase();
    

%>

<div class="content-wrapper">
<h1 class="box-title"><a href=<%= lien + "?but=budget/budget-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=consulte.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(consulte.getHtml());
                        %>

                        <div class="box-footer">
                            <% if(prevision.getEtat() > 0 && prevision.getEtat() < 11) { %>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=budget/budget-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <% } %>
                            <%
                                if( prevision.getEtat() != 11 ){ %>
<%--                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=budget/prevision-duplication.jsp&idPrevision=" + request.getParameter("id") %>" style="margin-right: 10px">Duplication</a>--%>
                            <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=budget/budget-saisie.jsp&acte=update&id=" + request.getParameter("id") %>" style="margin-right: 10px">Modifier</a>
<%--                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-liste-non-attache.jsp&idPrevision=" + request.getParameter("id") %>" style="margin-right: 10px">Attacher Mouvement Caisse</a>--%>
<%--                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=prevision/decalage/decalage-prevision-saisie.jsp&id=" + request.getParameter("id")+ "&debit=" + prevision.getDebit() +"&credit=" +  prevision.getCredit()+"&devise=" + prevision.getIdDevise()%>" style="margin-right: 10px">D�caler</a>--%>
<%--                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=prevision/prevision-scinder.jsp&idPrevision=" + request.getParameter("id")%>" style="margin-right: 10px">Scinder</a>--%>
                            <%    }
                            %>


                        </div>
                        <br/>
                    </div>
                </div>
            </div>      
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