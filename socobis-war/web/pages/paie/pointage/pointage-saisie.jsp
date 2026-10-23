<%-- 
    Document   : pointage_visee_saisie
    Created on : 8 mars 2019, 10:29:44
    Author     : EBI
--%>



<%@page import="paie.pointage.Pointage"%>
<%@page import="paie.service.PointageService"%>
<%@page import="user.UserEJB"%>
<%@page import="user.UserEJBClient"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="bean.TypeObjet"%>
<%@page import="paie.log.LogPersonnelInfoComplet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.CGenUtil"%>

<%

    try {
        UserEJB u = (UserEJB) session.getAttribute("u");
        String moisSelection = String.valueOf(Utilitaire.getMoisEnCoursReel());
        if (request.getParameter("mois") != null && !request.getParameter("mois").isEmpty()) {
            moisSelection = request.getParameter("mois");
        }
        String anneeSelection = Utilitaire.getAnneeEnCours();
        if (request.getParameter("anne") != null && !request.getParameter("anne").isEmpty()) {
            anneeSelection = request.getParameter("anne");
        }

        String semaineSelection = String.valueOf(Utilitaire.getWeekOfMonthFromDate(Utilitaire.dateDuJourSql()));
        if (request.getParameter("semaine") != null && !request.getParameter("semaine").isEmpty()) {
            semaineSelection = request.getParameter("semaine");
        }

        TypeObjet crt = new TypeObjet();
        crt.setNomTable("LOG_DIRECTION");
        TypeObjet[] dr = (TypeObjet[]) CGenUtil.rechercher(crt, null, null, null, "");

        TypeObjet crt2 = new TypeObjet();
        crt2.setNomTable("LOG_SERVICE_CRT");
        TypeObjet[] sec = (TypeObjet[]) CGenUtil.rechercher(crt2, null, null, null, "");

        String mois = request.getParameter("mois");
        String anne = request.getParameter("anne");
        if(anne==null)anne = Utilitaire.getAnneeEnCours();
        String semaine = request.getParameter("semaine");
        String drId = request.getParameter("dr");
        String matricule = request.getParameter("matricule");
        String categorie = request.getParameter("categorie");
        String section = request.getParameter("section");
        String afficherDebaucher = request.getParameter("afficherDebaucher");
        LogPersonnelInfoComplet p = new LogPersonnelInfoComplet();
        p.setNomTable("LOG_PERSONNEL_INFOCOMPLET3");
        String awere = "";
        if (drId != null && drId.compareToIgnoreCase("") != 0) {
            awere += " and direction='" + drId + "'";
        }
        if (matricule != null && matricule.compareToIgnoreCase("") != 0) {
            awere += " and matricule='" + matricule + "'";
        }
        
        String where="";
        if(afficherDebaucher != null && afficherDebaucher.compareToIgnoreCase("masquerDebaucher") == 0) {
            where += " and info.etat = 11 ";
        }

        matricule = (matricule != null && !matricule.isEmpty()) ? matricule : "%";
        drId = (drId != null && !drId.isEmpty()) ? drId : "%";

        TreeMap<Integer, List<java.sql.Date>> liste = Utilitaire.getListWeekWithDate(Integer.valueOf(moisSelection), Integer.valueOf(anneeSelection));
        if (!liste.containsKey(Integer.valueOf(semaineSelection))) {
            throw new Exception("Ne poss?de pas de semaine");
        }

        //getPointageVises(String mois, String annee, String matricule, String direction)
        Pointage[] val = PointageService.getPointageVises(mois, anne, matricule, drId,where);
        int taille = val.length; 

%>
<!DOCTYPE html>
<div class="content-wrapper">
    <section class="content-header">
        <h1 align="center"> Saisie d'un pointage </h1>
    </section>
    <section class="content">
        <form method="post" action="<%=(String) session.getValue("lien")%>?but=paie/pointage/pointage-saisie.jsp&currentMenu=MENDYN00001"> 
            <div class="row m-0">
                <div class="col-md-12 nopadding">
                    <div class="box box-solid collapsed cardradius" style="margin-top: 0">
                        <div class="box-header with-border" style="height: fit-content;display: flex;align-items: end;border: none !important;padding: 0;padding-bottom: 4px;">
                            <h3 class="h520pxSemibold m-0">
                                Recherche avanc&eacute;e
                            </h3>
                            <div class="box-tools pull-right">
                                <button data-original-title="Collapse" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="">
                                    <i class="fa fa-plus"></i>
                                </button> 
                            </div>
                        </div>
                        <div class="box-body" id="pagerecherche" style="padding: 20px 0;">
                            <div class="form-group">
                                <div class="col-md-4"><label for="id">Mois</label>
                                    <select class="form-control" id="mois" name="mois">
                                        <option value="">-</option>
                                        <%  for (int i = 1; i <= 12; i++) {%>

                                        <option value="<%=i%>"  <% if (i == Integer.valueOf(moisSelection)) {
                                                out.print(" selected ");
                                            }%> >
                                            <%=Utilitaire.nbToMois(i)%>
                                        </option>
                                        <% }%>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="anne" personnel="">Ann&eacute;e</label>
                                    <input name="anne" type="textbox" class="form-control" id="anne" value="<%=anneeSelection%>" onkeydown="return searchKeyPress(event)">
                                </div>
                                <div class="col-md-4"><label for="Date" min="">DR</label>
                                    <select class="form-control" id="dr" name="dr">
                                        <option value="">-</option>
                                        <% for (int i = 0; i < dr.length; i++) {%>
                                        <option value="<%=dr[i].getId()%>" <% if (request.getParameter("dr") != null && request.getParameter("dr").equals(dr[i].getId())) {
                                            out.print("selected");
                                        }%>>
                                            <%=dr[i].getVal()%>
                                        </option>
                                        <% }%>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="heure">Matricule</label>
                                    <input name="matricule" type="textbox" class="form-control" id="heure" value="<%=Utilitaire.champNull(request.getParameter("matricule"))%>" onkeydown="return searchKeyPress(event)">
                                </div>
                                <div class="col-md-4" style="margin-top:20px;">
                                    <select class="form-control" id="afficherDebaucher" name="afficherDebaucher">
                                        <option value="afficherDebaucher" <%if (afficherDebaucher != null && afficherDebaucher.equals("afficherDebaucher")) {
                                            out.print("selected");
                                        }%>>Afficher debauch&eacute;</option>
                                        <option value="masquerDebaucher" <%if (afficherDebaucher != null && afficherDebaucher.equals("masquerDebaucher")) {
                                            out.print("selected");
                                        }%>>Masquer debauch?</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="box-footer" style="border: none;">
                            <button type="submit" class="btn btn-primary pull-right" id="btnList">Afficher</button>
                            <button type="reset" class="btn btn-secondary pull-right" style="margin-right: var(--Bases-4-space-2)">R&eacute;initialiser</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <form method="post" action="/savonnerie/PointageServlet">
            <input type="hidden" name="action" value="enregistrerPointageVisee" />
            <input type="hidden" name="taille" value="<%=taille%>" />
            <input type="hidden" name="direction" value="<%=drId%>" />
            <div class="row m-0">
                <div class="col-md-12 nopadding">
                    <div class="cardradius" style="margin-top: 0">
                        <div class="box-header nopadding" style="padding-bottom: 4px;">
                            <h3 class="h520pxSemibold m-0"  >Liste des pointages</h3>
                        </div>
                        <div class="box-body table-responsive no-padding">
                            <div id="selectnonee">
                                <div class="table-responsive">
                                  <table class="table">
                                    <thead class="table-dark">
                                      <tr>
                                        <th class='contenuetable'>Matricule</th>
                                        <th class='contenuetable'>Personnel</th>
                                        <th class='contenuetable'>Heure normale</th>
                                        <th class='contenuetable'>Heure Suppl&eacute;mentaire Normale</th>
                                        <th class='contenuetable'>Heure Major&eacute;e F&eacute;ri&eacute;</th>
                                        <th class='contenuetable'>Heure Major&eacute;e Week-End</th>
                                        <th class='contenuetable'>Heure Major&eacute;e Nuit</th>
                                        <th class='contenuetable'>Heure d'absence</th>
                                      </tr>
                                    </thead>
                                    <tbody>
                                      <input type="hidden" name="mois" value="<%= moisSelection %>" />
                                      <input type="hidden" name="annee" value="<%= anneeSelection %>" />
                                      <% for (int i = 0; i < val.length; i++) { %>
                                      <input type="hidden" name="id<%= i %>" value="<%= Utilitaire.champNull(val[i].getId()) %>" />
                                      <tr>
                                        <td>
                                          <%= val[i].getMatricule() %>
                                          <input type="hidden" name="idPersonnel<%= i %>" value="<%= val[i].getIdPersonnel() %>" />
                                        </td>
                                        <td>
                                          <%= Utilitaire.champNull(val[i].getNom()) %> <%= Utilitaire.champNull(val[i].getPrenom()) %>
                                        </td>
                                        <td>
                                          <input type="text" class="form-control form-control-sm heurenormale"
                                                 id="heurenormal<%= val[i].getIdPersonnel() + semaineSelection %>"
                                                 name="heurenormal<%= i %>"
                                                 value="<%= Utilitaire.champNull(String.valueOf(val[i].getHeureNormal())) %>" />
                                        </td>
                                        <td>
                                          <input type="text" class="form-control form-control-sm heuresupnormal"
                                                 id="heuresupnormale<%= val[i].getIdPersonnel() + semaineSelection %>"
                                                 name="heuresupnormal<%= i %>"
                                                 value="<%= Utilitaire.champNull(String.valueOf(val[i].getHeureSupNormal())) %>" />
                                        </td>
                                        <td>
                                          <input type="text" class="form-control form-control-sm heuresupferie"
                                                 id="heuresupferie<%= val[i].getIdPersonnel() + semaineSelection %>"
                                                 name="heuresupferie<%= i %>"
                                                 value="<%= Utilitaire.champNull(String.valueOf(val[i].getHeureSupFerie())) %>" />
                                        </td>
                                        <td>
                                          <input type="text" class="form-control form-control-sm heuresupweekend"
                                                 id="heuresupweekend<%= val[i].getIdPersonnel() + semaineSelection %>"
                                                 name="heuresupweekend<%= i %>"
                                                 value="<%= Utilitaire.champNull(String.valueOf(val[i].getHeureSupWeekend())) %>" />
                                        </td>
                                        <td>
                                          <input type="text" class="form-control form-control-sm heuresupnuit"
                                                 id="heuresupnuit<%= val[i].getIdPersonnel() + semaineSelection %>"
                                                 name="heuresupnuit<%= i %>"
                                                 value="<%= Utilitaire.champNull(String.valueOf(val[i].getHeureSupNuit())) %>" />
                                        </td>
                                        <td>
                                          <input type="text" class="form-control form-control-sm absence"
                                                 id="absence<%= val[i].getIdPersonnel() + semaineSelection %>"
                                                 name="absence<%= i %>"
                                                 value="<%= Utilitaire.champNull(String.valueOf(val[i].getAbsence())) %>" />
                                        </td>
                                      </tr>
                                      <% } %>
                                    </tbody>
                                  </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row m-0">
              <div class="col-md-12 mb-5 nopadding">
                <div class="cardradius" >
                  <div class="box-header nopadding" style="padding-bottom: 4px;">
                    <h2 class="h520pxSemibold m-0" >Mois et ann&eacute;e prise en charge</h2>
                  </div>
                  <div class="input-container" style="padding: 20px 0;">
                    <div class="form-input">
                      <label for="mois">Mois</label>
                      <select class="form-control" id="moisp" name="moisp">
                        <% for (int i = 1; i <= 12; i++) {%>
                        <option value="<%=i%>" <% if (i == Integer.valueOf(moisSelection)) {
                                out.print(" selected ");
                            }%>><%=Utilitaire.nbToMois(i)%></option>
                        <% }%>
                      </select>
                    </div>
                    <div class="form-input">
                        <label for="annee">Ann&eacute;e</label>
                      <input type="text" class="form-control" id="annee" value="<%=anneeSelection%>" name="annee">
                    </div>
                  </div>
                  <div class="box-footer">
                    <input type="submit" class="btn btn-primary pull-right" value="Inserer" style="margin-left: 5px;">
                  </div>
                </div>
              </div>
            </div>
        </form>
    </section>
</div>
<%} catch (Exception e) {
        e.printStackTrace();
        throw e;
    }%>