    /*
    * To change this license header, choose License Headers in Project Properties.
    * To change this template file, choose Tools | Templates
    * and open the template in the editor.
    */
    package paie.node;

    import bean.ClassMAPTable;
    import java.sql.Connection;

    /**
     *
     * @author Sambatra Rakotondrainibe
     */

    public class Node extends ClassMAPTable {

        private String id,idpers,parent;


        public Node() {
            this.setNomTable("node");
        }

        

        public Node(String idpers, String parent) {
            this.idpers = idpers;
            this.parent = parent;
            this.setNomTable("node");
        }



        public Node(String id, String idpers, String parent) {
            this.setNomTable("node");
            this.id = id;
            this.idpers = idpers;
            this.parent = parent;
        }



        public String getIdpers() {
            return idpers;
        }



        public void setIdpers(String idpers) {
            this.idpers = idpers;
        }



        public String getParent() {
            return parent;
        }



        public void setParent(String parent) {
            this.parent = parent;
        }



        @Override
        public void construirePK(Connection c) throws Exception {

            this.preparePk("NOD", "GET_SEQ_NODE");
            this.setId(makePK(c));
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }


        @Override
        public String getTuppleID() {
            return id;
        }

        @Override
        public String getAttributIDName() {
            return "id";
        }

    }

