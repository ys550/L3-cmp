-- ============================= TB_Comparateur.vhd ====================================
-- ELE140 Conception des systemes numeriques
-- AUT2016, Ecole de technologie superieure
-- Redige par Ibtissam Kaissoumi, 2016-09-11
--======================================================================================
-- Description: 
--   Testbench pour tester le module CompNBits.vhd
--   Les donnees sont lues a partir du fichier data_in.txt
--   La sortie est dirigee vers data_out.txt
--======================================================================================
-- Declaration des librairies
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use IEEE.std_logic_textio.all;
library std;
    use std.textio.all;
use work.txt_util.all;

entity TB_Comparateur is -- L'entite du testbench est toujours vide
end TB_Comparateur;

-- Architecture du testbench
architecture arch_testbench of TB_Comparateur is
    -- Declarations des constantes
    constant N : integer := 16;
    constant PERIODE    : time := 20 ns; --Periode de l'horloge

-- COMMENTAIRE 1 : 
Component CompNBits is
	--Constante 
	GENERIC (N : integer := N);	
    port (
        	A  : in std_logic_vector (N-1 downto 0);
        	B  : in std_logic_vector (N-1 downto 0);
        	PP : out std_logic; 
        	PG : out std_logic; 
        	EG : out std_logic);
end component;
  
  -- COMMENTAIRE 2 : 
  signal A_in, B_in  : std_logic_vector (N-1 downto 0); 
  signal PP_out, PG_out, EG_out : std_logic;
  signal clk: std_logic;
  
  begin
    -- Instanciation de l'UUT (Unit Under Test)
    Connexion: CompNBits generic map (
				N => 16
			   ) 
                	   port map    (  
				A  => A_in,
                B  => B_in,
                PP => PP_out,
                PG => PG_out,
                EG => EG_out
			   );

    -- 1er Process : Pour l'horloge
    process
    begin
        clk <= '1';
        wait for PERIODE/2;
        clk <= '0';
        wait for PERIODE/2;
    end process;    
    
    -- 2e Process : Principal/Fonctionnement du testbench 
    process 
        -- COMMENTAIRE 3 : 
        file data_txt: text open READ_MODE  is "data_in.txt"; -- COMMENTAIRE 4: 
        file data_out: text open WRITE_MODE is "data_out.txt"; -- COMMENTAIRE 5 : 
   
        -- COMMENTAIRE 6 : 
        variable Input1_A, Input2_B : std_logic_vector (N-1 downto 0);
	    variable PP_out_th, PG_out_th, EG_out_th : std_logic; -- COMMENTAIRE 7 : 
        variable Une_Erreur : std_logic := '0'; -- COMMENTAIRE 8 : 

        -- Variables de lecture. 
        variable ligne_texte, ligne_texte2 : line;
        variable operation_ok : boolean;
        variable char_pour_espace : character;
        
    begin
        -- COMMENTAIRE 9 : 
        A_in  <= (others=>'0');
        B_in  <= (others=>'0');
      
	    -- COMMENTAIRE 10 : 
        wait for PERIODE;
        
        -- COMMENTAIRE 11 : 
        w1: while not endfile(data_txt) loop
            -- Lire une ligne d'entree du fichier
            readline(data_txt, ligne_texte);

            -- COMMENTAIRE 12 :
            hread(ligne_texte, Input1_A, operation_ok);
            -- COMMENTAIRE 13 :
            next when not operation_ok;
            -- COMMENTAIRE 14 :
            read(ligne_texte, char_pour_espace);

       
            hread(ligne_texte, Input2_B);
            read(ligne_texte, char_pour_espace);
 
            -- COMMENTAIRE 15 :
             read(ligne_texte, PP_out_th);
             read(ligne_texte, char_pour_espace);

             read(ligne_texte, PG_out_th);
             read(ligne_texte, char_pour_espace);

             read(ligne_texte, EG_out_th);
             read(ligne_texte, char_pour_espace);

            -- COMMENTAIRE 16 :
            A_in<=Input1_A;
            B_in<=Input2_B;

            wait for PERIODE; -- Resultat pret seulement apres un certain delais
			
	       -- COMMENTAIRE 17 :
            if (PP_out_th=PP_out and PG_out_th=PG_out and EG_out_th=EG_out) then
                write(ligne_texte2, "A = " & hstr(Input1_A) & 
                                " B = " & hstr(Input2_B) &
                                " PP_Theorique = " & str(PP_out_th) & " PG_Theorique = " & str(PG_out_th) & " EG_Theorique = " & str(EG_out_th) &
                                " PP_obtenu = " & str(PP_out) & " PG_obtenu = " & str(PG_out) & " EG_obtenu = " & str(EG_out) & " : SUCCES");          
            else
                write(ligne_texte2, "A = " & hstr(Input1_A) & 
                                " B = " & hstr(Input2_B) &
                                " PP_Theorique = " & str(PP_out_th) & " PG_Theorique = " & str(PG_out_th) & " EG_Theorique = " & str(EG_out_th) &
                                " PP_obtenu = " & str(PP_out) & " PG_obtenu = " & str(PG_out) & " EG_obtenu = " & str(EG_out) & " : ECHEC");  
                Une_Erreur := '1';          
            end if; 
			
            -- COMMENTAIRE 18 :                                 
            assert (PP_out_th/=PP_out or PG_out_th/=PG_out or EG_out_th/=EG_out)
                report "Operation reussie. Resultat = " & " " & str(PP_out) & " " & str(PG_out) & " " & str(EG_out)
                severity note;
            assert (PP_out_th=PP_out and PG_out_th=PG_out and EG_out_th=EG_out)
                report "Operation echouee Resultat = "  & " " & str(PP_out) & " " & str(PG_out) & " " & str(EG_out)
                severity note;
				
         -- COMMENTAIRE 19 :  
            writeline(data_out, ligne_texte2);
                 
        end loop w1;
        
	     -- COMMENTAIRE 20 : 	
        assert (Une_Erreur='1') 
            report "testbench pour CompNBits.vhd termine avec succes" severity note;
        assert (Une_Erreur='0') 
            report "testbench pour CompNBits.vhd termine avec echec" severity note;
	

	    -- COMMENTAIRE 21 : 
        file_close(data_txt);
        file_close(data_out);
		
        wait; -- -- COMMENTAIRE 22 : 
    end process; -- Fin du process de test
end arch_testbench;
            