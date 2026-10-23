<%--
    Document   : personnelnonvalide-fiche
    Created on : 9 d�c. 2015, 12:05:02
    Author     : Jetta
--%>

<%@page import="paie.avancement.PaieAvancement"%>
<%@page import="paie.log.LogPersonnelNonValide"%>
<%@page import="paie.employe.DecDecision"%>
<%@page import="paie.employe.DecDecisionType"%>
<%@page import="paie.log.LogPersnonValideComplet"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%!
    LogPersnonValideComplet personnel;
%>


<%try { %>
<%
    String dossier = "op";
    String pageActuel = "paie/employe/personnelnonvalide-fiche.jsp";

    UserEJB u = (UserEJB) session.getAttribute("u");
    String lien = (String) session.getValue("lien");
    personnel = new LogPersnonValideComplet();
    personnel.setNomTable("LOG_PERS_NON_VALIDE_LIB_5");
    //String[] libellePersonnelFiche = {"id", "Nom ","Sexe","Date application","Motif","Etat","User","Matricule","Date d�cision","R�f�rence decision","ID personnel"};
    PageConsulte pc = new PageConsulte(personnel, request, (user.UserEJB) session.getValue("u"));
    pc.getChampByName("sexe").setVisible(false);
    pc.getChampByName("idlogpers").setVisible(false);
    pc.getChampByName("idavancement").setVisible(false);
    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("dateapplication").setLibelle("Date d'application");
    pc.getChampByName("date_decision").setLibelle("Date de d&eacute;cision");
    pc.getChampByName("refdecision").setLibelle("R&eacute;f&eacute;rence de d&eacute;cision");
    pc.getChampByName("motif").setLibelle("Pr&eacute;avis");
    pc.getChampByName("typedebauche").setLibelle("Type de d&eacute;bauche");
    pc.getChampByName("idtypedebauche").setVisible(false);
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("personnelid").setLibelle("Personnel");
    pc.getChampByName("idpassation").setLibelle("Passation de service");
    // pc.setLibAffichage(libellePersonnelFiche);
    pc.setTitre("Fiche Personnel non Valide ");

    LogPersnonValideComplet data = (LogPersnonValideComplet) pc.getBase();
    pc.getChampByName("personnelid").setLien((String) session.getValue("lien") + "?but=paie/employe/personnel-fiche-portrait.jsp&id="+data.getIdlogpers(),"nom=");
    pc.getChampByName("idpassation").setLien((String) session.getValue("lien") + "?but=paie/employe/personnel-fiche-portrait.jsp&id="+data.getIdlogpers(),"nom=");

    LogPersnonValideComplet lpvc = new LogPersnonValideComplet();
    lpvc.setNomTable("LOG_PERS_STC");
    String titre = "";
    if (data.getSexe().compareToIgnoreCase("1") == 0) {
        titre = "Monsieur";
    } else {
        titre = "Madame";
    }
    LogPersonnelNonValide[] datapers = (LogPersonnelNonValide[]) u.getData(new LogPersonnelNonValide(), null, null, null, " AND ID = '" + data.getId() + "'");
    personnel = (LogPersnonValideComplet) pc.getBase();

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/stc-fiche", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/stc-fiche";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    String idpersonnel = pc.getChampByName("idlogpers").getValeur();
    String dateapplication = pc.getChampByName("dateapplication").getValeur();
    System.out.println("dateapplication==>"+dateapplication);
    String mois = Utilitaire.getMois(dateapplication);
    String annee= Utilitaire.getAnnee(dateapplication);

%>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=paie/employe/personnelnonvalide-liste.jsp"%>> <i class="fa fa-angle-left"></i></a>Fiche du Personnel non valide</h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <%
                                String baselien = (String) session.getValue("lien");
                                String id = "&id=" + request.getParameter("id");
                                String apresdepart = "?but=paie/employe/apresdepart.jsp";
                                String butmodif = "?but=paie/employe/personnelnonvalide-saisie.jsp";
                                String ficheredirect = "&redirect=paie/employe/personnelnonvalide-fiche.jsp";
                                String buteliste = "&bute=paie/employe/personnelnonvalide-liste.jsp";
                                String classe = "paie.log.LogPersonnelNonValide";

                                if (data.getEtat() < 11) {
                            %>

                          
                            <a class="btn btn-primary pull-right"  href="<%=baselien + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=valider&bute=paie/employe/personnelnonvalide-fiche.jsp&classe=paie.log.LogPersonnelNonValide" style="margin-right: 10px">Viser</a>

                            <a class="btn btn-secondary pull-right"  href="<%=baselien + butmodif + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>

                            <a class="btn btn-danger pull-left"  href="<%=baselien + apresdepart + id + "&acte=delete" + buteliste + ficheredirect + classe%>" style="margin-right: 10px">Supprimer</a>
                            <% } else { %>
                            <a class="btn btn-success pull-right"  href="<%=baselien + "?but=apresSpecifique.jsp&id=" + request.getParameter("id")%>&acte=genererStc&bute=paie/employe/personnelnonvalide-fiche.jsp" style="margin-right: 10px">Generer Stc</a>
                            <% } %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") %>" style="margin-right: 10px;">Attacher Fichier</a>
                            <!--<a class="btn btn-success pull-right"  href="<%=baselien + "?but=paie/employe/personnel-fiche.jsp&id="+personnel.getPersonnelid()+"&page=conge&currentMenu=ELM000650"%> " style="margin-right: 10px">Aller vers fiche</a>-->

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
        pc.setCritere(new LogPersonnelNonValide());
        pc.setBase(new LogPersonnelNonValide());
    %>

    <div class="row">
        <%
            PaieAvancement[] avancement = (PaieAvancement[]) u.getData(new PaieAvancement(), null, null, null, " AND ID = '" + datapers[0].getIdavancement() + "'");
            if (avancement != null && avancement.length > 0) {
        %>
        <div class="col-md-6">
            <div class="box-fiche mb-5 ">
                <div class="box">
                    <div class="box-body">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>R&eacute;f&eacute;rence</th>
                                <th>Id</th>
                                <th>Etat</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>Avancement</td>
                                <td><a href="<%=lien + "?but=paie/avancement/avancement-fiche.jsp&id=" + avancement[0].getId()%>"><%=avancement[0].getId()%></a></td>
                                <td><%=avancement[0].getEtatText(avancement[0].getEtat())%></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("inc/stc-fiche")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/stc-fiche">Solde de Tout Compte</a></li>
                </ul>

                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idpersonnel" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>
        </div>
        <% } %>

    </div>
    <%=pc.getHtmlAttacherFichier()%>
    <%
    } catch (Exception e) {
        e.printStackTrace();
    %>
    <script language="JavaScript"> alert('<%=e.getMessage()%>');
        history.back();</script>
    <%
            return;
        }
    %>

</div>
