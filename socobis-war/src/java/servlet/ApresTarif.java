package src.java.servlet;

import affichage.Page;
import affichage.PageInsert;
import bean.CGenUtil;
import bean.ClassMAPTable;
import change.TauxDeChange;
import com.google.gson.Gson;
import user.UserEJB;
import utilitaire.Utilitaire;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ApresTarif")
public class ApresTarif extends HttpServlet {
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String typeBoutton;
    String champReturn;
    String action = null;
    private static final Gson gson = new Gson();
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        System.out.println("NIDITRA TATO ANATY SERVLETSS");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        Map<String, Object> res = new HashMap<>();
        try {
            nomtable = request.getParameter("nomtable");
            typeBoutton = request.getParameter("type");
            lien = (String) session.getValue("lien");
            u = (UserEJB) session.getAttribute("u");
            acte = request.getParameter("acte");
            bute = request.getParameter("bute");
            action = request.getParameter("action");
            Object temp = null;
            String[] rajoutLien = null;
            String classe = request.getParameter("classe");

            ClassMAPTable t = null;
            String tempRajout = request.getParameter("rajoutLien");
            String val = "";
            String id = request.getParameter("id");
            champReturn = request.getParameter("champReturn");
            String rajoutLie = "";
            if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
                rajoutLien = utilitaire.Utilitaire.split(tempRajout, "-");
            }
            String tempRajoutLienFormu = request.getParameter("rajoutLienFormu");
            String rajoutLieFormu = "";
            String[] rajoutLienFormu = null;
            if (tempRajoutLienFormu != null && tempRajoutLienFormu.compareToIgnoreCase("") != 0) {
                rajoutLienFormu = utilitaire.Utilitaire.split(tempRajoutLienFormu, "-");
                if(rajoutLienFormu.length == 2){
                    rajoutLieFormu = "&"+rajoutLienFormu[0]+"="+rajoutLienFormu[1];
                }
            }
            String acteDetail=request.getParameter("acteDetail");

            if (typeBoutton == null || typeBoutton.compareToIgnoreCase("") == 0) {
                typeBoutton = "3"; //par defaut modifier
            }

            if (rajoutLien != null) {

                for (int o = 0; o < rajoutLien.length; o++) {
                    String valeur = request.getParameter(rajoutLien[o]);
                    rajoutLie = rajoutLie + "&" + rajoutLien[o] + "=" + valeur;

                }

            }

            String champUrl = request.getParameter("champUrl");
            if(champUrl!=null){
                bute = "popup/apresPopup.jsp";
            }

            int type = Utilitaire.stringToInt(typeBoutton);
            if (acte.compareToIgnoreCase("insertMenu") == 0) {
                String utilisateur = request.getParameter("refuser");
                String menu = request.getParameter("idmenu");
                //String idrole = request.getParameter("idrole");
                String acces = request.getParameter("interdit");
                u.ajouterMenuUtilisateur(utilisateur, menu, null, acces);
            }

            if (acte.compareToIgnoreCase("insert") == 0) {
                t = (ClassMAPTable) (Class.forName(classe).newInstance());
                PageInsert p = new PageInsert(t, request);
                ClassMAPTable f = p.getObjectAvecValeur();

                f.setNomTable(nomtable);
                String idAretourner=null;
                if(f.getTuppleID()!=null&&f.getTuppleID().compareToIgnoreCase("")!=0){
                    idAretourner = f.getTuppleID();
                    f.setTuppleId(null);
                }
                ClassMAPTable o = (ClassMAPTable) u.createObject(f);
                lien=lien.replace("module.jsp","moduleLeger.jsp");
                temp = (Object) o;
                if (o != null) {
                    if(idAretourner!=null) id = idAretourner;
                    else id = o.getTuppleID();
                    res.put("status", "success");
                    res.put("id", id);
                    res.put("butApres", lien+"?but="+bute+rajoutLie+"&id="+id);
                }
            }
            if (acte.compareToIgnoreCase("update") == 0) {
                t = (ClassMAPTable) (Class.forName(classe).newInstance());
                Page p = new Page(t, request);
                ClassMAPTable f = p.getObjectAvecValeur();
                temp = f;
                if (nomtable != null) {
                    f.setNomTable(nomtable);
                }
                u.updateObject(f);
                id = f.getTuppleID();
                if (id != null) {
                    res.put("status", "success");
                    res.put("id", id);
                    res.put("butApres", lien+"?but="+bute+rajoutLie+"&id="+id);
                }
            }
            out.print(gson.toJson(res));
            out.flush();
        } catch (Exception e) {
            res.put("status", "error");
            res.put("message", e.getMessage());
            out.print(gson.toJson(res));
            out.flush();
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        super.doPost(req, resp);
    }

}
