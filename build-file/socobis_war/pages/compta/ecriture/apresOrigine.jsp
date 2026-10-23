<%@ page import="java.net.URLEncoder" %>
<%@ page import="mg.cnaps.compta.Journal" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
  try {
    String lien = (String) session.getAttribute("lien");
    String idOrigine = request.getParameter("id");
    String pageDestination;

    if (lien == null || lien.trim().isEmpty()) {
      throw new Exception("Le lien principal est absent de la session.");
    }

    if (idOrigine == null || idOrigine.trim().isEmpty()) {
      throw new Exception("L'identifiant d'origine est obligatoire.");
    }
    idOrigine = idOrigine.trim();
    if (idOrigine.startsWith("VNT")) {
      pageDestination = "vente/vente-fiche.jsp";
    } else if (idOrigine.startsWith("RPRC")) {
      pageDestination = "caisse/report/reportCaisse-fiche.jsp";
    } else if (idOrigine.startsWith("FCF")) {
      pageDestination = "facturefournisseur/facturefournisseur-fiche.jsp";
    }  else if (idOrigine.startsWith("MVTST")) {
      pageDestination = "stock/mvtstock-fiche.jsp";
    } else if (idOrigine.startsWith("MTC")) {
      pageDestination = "caisse/mvt/mvtCaisse-fiche.jsp";
    } else if (idOrigine.startsWith("MVTF")) {
      pageDestination = "caisse/mvt/mvtCaisse-fiche.jsp";
    }else if (idOrigine.startsWith("DTVA")) {
      pageDestination = "declaration/fiche-declaration-tva.jsp";
    } else {
      try {
        Journal journal = new Journal().getJournalByVal(null, idOrigine);
        idOrigine = journal.getId();
        pageDestination = "compta/journal/journal-fiche.jsp";
      } catch (Exception e) {
          throw new Exception(
                  "Type d'origine inconnu : " + idOrigine
          );
      }
    }

    String idEncode = URLEncoder.encode(idOrigine, "UTF-8");

    String destination = lien
            + "?but=" + pageDestination
            + "&id=" + idEncode;

    // Protection avant insertion dans le JavaScript
    String destinationJS = destination
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\r", "")
            .replace("\n", "");

%>

<script type="text/javascript">
  window.location.replace("<%= destinationJS %>");
</script>

<%
  return;

} catch (Exception e) {
  String messageErreur = String.valueOf(e.getMessage())
          .replace("\\", "\\\\")
          .replace("\"", "\\\"")
          .replace("'", "\\'")
          .replace("\r", "")
          .replace("\n", "\\n");
%>

<script type="text/javascript">
  alert("<%= messageErreur %>");
  history.back();
</script>

<%
    return;
  }
%>