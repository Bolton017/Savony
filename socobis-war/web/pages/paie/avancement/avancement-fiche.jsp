<%@page import="paie.employe.MsMissionAttachement"%>
<%@page import="paie.employe.PaieInfoPersonnel"%>
<%@page import="paie.employe.DecDecision"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.Utilitaire" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="paie.avancement.PaieAvancementLibelle" %>
<%@ page import="paie.avancement.PaieAvancementLibelle2" %>
<%@ page import="paie.log.LogPersonnelNonValide" %>

<%!
  PaieAvancementLibelle2 avancement;
  UserEJB u;
%>

<% try {
  String dossier = "op";
  String pageActuel = "paie/avancement/avancement-fiche.jsp";

  u = (UserEJB) session.getAttribute("u");
  String lien = (String) session.getValue("lien");
  avancement = new PaieAvancementLibelle2();
  avancement.setNomTable("PAIE_AVANCEMENT_LIBELLE4");

  PageConsulte pc = new PageConsulte(avancement, request, (user.UserEJB) session.getValue("u"));
  pc.getChampByName("motif").setLibelle("Type d'avancement");

  PaieAvancementLibelle data = (PaieAvancementLibelle) pc.getBase();
  if(data.getIdmotif()!=null && data.getIdmotif().equalsIgnoreCase("TYD000010")){
    pc.getChampByName("regionlib").setLibelle("R&eacute;gion d'affectation");
  }
  pc.getChampByName("regionlib").setLibelle("R&eacute;gion d'affectation");
  pc.getChampByName("id_logpers").setLibelle("Nom et pr&eacute;noms");
  pc.getChampByName("idpers").setLibelle("ID personnel");
  pc.getChampByName("datedecision").setLibelle("Date de d&eacute;cision");
  pc.getChampByName("refdecision").setLibelle("R&eacute;f&eacute;rence de d&eacute;cision");
  pc.getChampByName("date_application").setLibelle("Date d'application");
  pc.getChampByName("fonctionLib").setLibelle("Fonction");
  pc.getChampByName("ctg").setLibelle("Cat&eacute;gorie sp&eacute;cifique");
  pc.getChampByName("idcategorie").setLibelle("Qualification");
  pc.getChampByName("classee").setLibelle("Classe");
  pc.getChampByName("indicegrade").setLibelle("Indice");
  pc.getChampByName("etat").setLibelle("&Eacute;tat");
  pc.getChampByName("indice_fonctionnel").setVisible(false);
  pc.getChampByName("sexe").setVisible(false);
  pc.getChampByName("vehiculee").setVisible(false);
  pc.getChampByName("service").setLibelle("Section");
  pc.getChampByName("echelon").setLibelle("Groupe");
  pc.getChampByName("code_banque").setLibelle("Code bancaire");
  pc.getChampByName("DIRECTION").setVisible(false);
  pc.getChampByName("vehiculee_str").setVisible(false);
  pc.getChampByName("droit_hs").setVisible(false);
  pc.getChampByName("matricule_patron").setVisible(false);
  pc.getChampByName("indice_ct").setVisible(false);
  pc.getChampByName("ctg").setVisible(false);
  pc.getChampByName("classee").setVisible(false);
  pc.getChampByName("idmotif").setVisible(false);
  pc.getChampByName("idmotif").setVisible(false);
  pc.getChampByName("statut").setVisible(false);
  pc.getChampByName("indicegrade").setVisible(false);
  pc.getChampByName("echelon").setVisible(false);
  pc.getChampByName("idFonction").setVisible(false);


  pc.setTitre("Fiche de Changement de contrat");

  PaieInfoPersonnel[] pers = (PaieInfoPersonnel[]) u.getData(new PaieInfoPersonnel(), null, null, null, " AND ID = '" + data.getIdpers() + "' AND ETAT = 11");
  boolean isPersonnel = pers != null && pers.length > 0;
%>
<div class="content-wrapper">
  <h1><%= pc.getTitre() %></h1>
  <div class="row m-0">
    <div class="col-md-6">
      <div class="box-fiche">
        <div class="box">
          <div class="box-body">
            <%
              if (isPersonnel) {
                pc.getChampByName("idpers").setVisible(true);
                pc.getChampByName("idpers").setLien(new PageConsulteLien(lien + "?but=paie/employe/personnel-fiche.jsp&id=" + data.getIdpers(), ""));
              }
              out.println(pc.getHtml());
            %>
            <br/>
            <div class="box-footer">
              <%
                String id = "&id=" + request.getParameter("id");
                String apresmvt = "?but=paie/avancement/apresmouvement.jsp";
                String butmodif = "?but=paie/avancement/avancement-modif.jsp";
                String classe = "&classe=paie.avancement.PaieAvancement";
                String butefiche = "&bute=paie/avancement/avancement-fiche.jsp";
                String buteliste = "&bute=paie/avancement/avancement-liste.jsp";
                String ficheredirect = "&redirect=paie/avancement/avancement-fiche.jsp";
                //String butmission = "?but=paie/mission/mission-attachement.jsp";
                String motifMS = "&motifMS=" + data.getMotif();
                String idObj = "&idobj=" + request.getParameter("id");
              %>
              <% if (data.getEtat() != 11) {%>
              <a class="btn btn-primary pull-right" href="<%=lien + "?but=apresTarif.jsp&acte=valider" + id +butefiche+classe %>" style="margin-right: 10px">Viser</a>
              <% }%>
              <a class="btn btn-secondary pull-right" href="<%=lien + butmodif + id%>" style="margin-right: 10px">Modifier</a>
              <a class="btn btn-danger pull-left" href="<%=lien + "?but=apresTarif.jsp" + id + "&acte=delete&bute=paie/avancement/avancement-liste.jsp" + classe%>" style="margin-right: 10px">Supprimer</a>
              <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") %>" style="margin-right: 10px;">Attacher Fichier</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row">
    <%
      LogPersonnelNonValide[] persnonvalide = (LogPersonnelNonValide[]) u.getData(new LogPersonnelNonValide(), null, null, null, " AND IDAVANCEMENT = '" + request.getParameter("id") + "'");
      if (persnonvalide != null && persnonvalide.length > 0) {
    %>
    <div class="col-md-6">
      <div class="box-fiche">
        <div class="box">
          <div class="box-body">
            <table class="table table-bordered">
              <thead>
              <tr>
                <th>R&eacute;f&eacute;rence</th>
                <th>Id</th>
                <th>Etat</th>
              </tr>
              </thead>
              <tbody>
              <tr>
                <td>Personnel non valide</td>
                <td><a href="<%=lien + "?but=paie/employe/personnelnonvalide-fiche.jsp&id=" + persnonvalide[0].getId()%>"><%=persnonvalide[0].getId()%></a></td>
                <td><%=persnonvalide[0].getEtatText(persnonvalide[0].getEtat())%></td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <% } %>
  </div>

<%--  <div class="row">--%>
<%--    <!-- attachement mission -->--%>
<%--    <%--%>
<%--      MsMissionAttachement[] mission = (MsMissionAttachement[]) u.getData(new MsMissionAttachement(), null, null, null, " AND IDOBJET = '" + request.getParameter("id") + "'");--%>
<%--      if (mission != null && mission.length > 0) {--%>
<%--    %>--%>
<%--    <div class="col-md-6">--%>
<%--      <div class="box-fiche">--%>
<%--        <div class="box">--%>
<%--          <div class="box-title with-border">--%>
<%--            <h1 class="box-title">Mission associ&eacute;e</h1>--%>
<%--          </div>--%>
<%--          <div class="box-body">--%>
<%--            <table class="table table-bordered">--%>
<%--              <thead>--%>
<%--              <tr>--%>
<%--                <th>Id</th>--%>
<%--                <th>ID Mission</th>--%>
<%--                <th>Description</th>--%>
<%--                <th>Actions</th>--%>
<%--              </tr>--%>
<%--              </thead>--%>
<%--              <tbody>--%>
<%--              <% for (int i = 0; i < mission.length; i++) {%>--%>
<%--              <tr>--%>
<%--                <td><%=mission[i].getId()%></td>--%>
<%--                <td>--%>
<%--                  <a href="<%=(String) session.getValue("lien") + "?but=paie/mission/mission-fiche.jsp&id=" + mission[i].getIdmission()%>">--%>
<%--                    <%=Utilitaire.champNull(mission[i].getIdmission())%>--%>
<%--                  </a>--%>
<%--                </td>--%>
<%--                <td><%=Utilitaire.champNull(mission[i].getDescription())%></td>--%>
<%--                <td><a href="<%=lien + "?but=paie/mission/apresMission.jsp&id=" + request.getParameter("id") + "&acte=detachementMS" + "&bute=paie/avancement/avancement-fiche.jsp&idAtt=" + mission[i].getId()%>">D&eacute;tacher</a></td>--%>
<%--              </tr>--%>
<%--              <% } %>--%>
<%--              </tbody>--%>
<%--            </table>--%>
<%--          </div>--%>
<%--        </div>--%>
<%--      </div>--%>
<%--    </div>--%>
<%--    <% } %>--%>
<%--  </div>--%>

  <!-- decision -->
  <%
    if (data.getMotif() != null && !data.getMotif().isEmpty()) {
      if (data.getEtat() == ConstanteEtat.getEtatValider() || data.getEtat() == ConstanteEtat.getEtatAnnuler()) {
  %>
  <div class="row">
    <div class="col-md-6">
      <div class="box-fiche">
        <div class="box">
          <div class="box-title with-border">
            <h1 class="box-title">D&eacute;cision</h1>
          </div>
          <div class="box-body">
          </div>
        </div>
      </div>
    </div>
  </div>
  <% }
  }%>
  <%=pc.getHtmlAttacherFichier()%>
</div>

<%
} catch (Exception e) {
  e.printStackTrace();
%>

<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();</script>
<% } %>
