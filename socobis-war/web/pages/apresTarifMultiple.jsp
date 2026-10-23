<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="affichage.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
	UserEJB u = null;
	String acte = null;
	String lien = null;
	String bute;
	String idMere = null;
	String nomTableUnion = null;
%>
<%
	try {
		lien = (String) session.getValue("lien");
		u = (UserEJB) session.getAttribute("u");
		acte = request.getParameter("acte");
		bute = request.getParameter("bute");
		Object temp = null;
		String[] rajoutLien = null;
		String classe = request.getParameter("classe");
		String classeUnion = request.getParameter("classeUnion");
		ClassMAPTable t = null;
		String tempRajout = request.getParameter("rajoutLien");
		String val = "";
		String rajoutLie = "";
		idMere = request.getParameter("idMere");
		nomTableUnion = request.getParameter("nomTable");
		if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
			rajoutLien = utilitaire.Utilitaire.split(tempRajout, "-");
		}
		if (bute == null || bute.compareToIgnoreCase("") == 0) {
			bute = "pub/Pub.jsp";
		}

		if (classe == null || classe.compareToIgnoreCase("") == 0) {
			classe = "pub.Montant";
		}
		if (acte.compareToIgnoreCase("detacher") == 0) {
			String error = "";
			try {
				String[] liste_id_fille = request.getParameterValues("id");
				t = (ClassMAPTable) (Class.forName(classeUnion).newInstance());
				if (nomTableUnion == null) {
					u.deleteMereFille(t, idMere, liste_id_fille);
				} else {
					u.deleteMereFille(t, nomTableUnion, idMere, liste_id_fille);
				}
			} catch (Exception e) {
				out.println("<script language=\"JavaScript\">alert(\"Erreur durant la suppression\")</script>");
			}

		}

		if (acte.compareToIgnoreCase("valider") == 0) {
			String error = "";
			try {
				t = (ClassMAPTable) (Class.forName(classe).newInstance());
				t.setValChamp("id", idMere);
				u.cloturerObject(t);
			} catch (Exception e) {
				out.println("<script language=\"JavaScript\">alert(\"Erreur durant la validation\")</script>");
			}

		}

		if (acte.compareToIgnoreCase("attacher") == 0) {
			String error = "";
			try {
				String[] liste_id_fille = request.getParameterValues("id");
				t = (ClassMAPTable) (Class.forName(classe).newInstance());
				if (request.getParameter("nomTable") == null) {
					u.mapperMereFille(t, idMere, liste_id_fille, "", "0", "0");
				} else {
					u.mapperMereFille(t, nomTableUnion, idMere, liste_id_fille, "", "0", "0");
				}

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("<<<<<<<<<<<<< " + e.getMessage());
				out.println("<script language=\"JavaScript\">alert(\"Erreur durant l\'attachement\")</script>");
			}
		}
		if (acte.compareToIgnoreCase("update") == 0) {
			t = (ClassMAPTable) (Class.forName(classe).newInstance());
			Page p = new Page(t, request);
			ClassMAPTable f = p.getObjectAvecValeur();
			u.updateObject(f);
		}
		if (acte.compareToIgnoreCase("savePlanRemboursement") == 0) {
			String error = "";
			try {
				u.savePlanRemboursement(request);
			} catch (Exception e) {
				//out.println("<script language=\"JavaScript\">alert(\""+e.getMessage()+"\")</script>");
				throw e;
			}

		}

		if (rajoutLien != null) {
			for (int o = 0; o < rajoutLien.length; o++) {
				String valeur = request.getParameter(rajoutLien[o]);

			}

		}
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute + rajoutLie%>&idMere=<%=idMere%>");</script>
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
</html>



