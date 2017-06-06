<?php
/*                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
    Contact: Jean.Suzineau@wanadoo.fr                                           |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                              */
include_once( "cpoolNom_de_la_table.php");

$HTTP_request_body = file_get_contents('php://input');

$id=$_GET["id"];
$json=$HTTP_request_body;

$poolNom_de_la_table= new cpoolNom_de_la_table();

$poolNom_de_la_table->Ecrire_json( $id, $json);


echo $poolNom_de_la_table->json_Charge_Ligne( $id);
?>




