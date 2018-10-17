-- Declaration des libraries
library IEEE;
    use IEEE.std_logic_1164.all;

entity CompNbits is       --Definition de l'entité

    GENERIC (N : integer := 4);
    port (
--            Entrees Nbits
            A  : in std_logic_vector (N-1 downto 0);
            B  : in std_logic_vector (N-1 downto 0);
--            Sorties Nbits
            PP : out std_logic;
            PG : out std_logic;
            EG : out std_logic);
end CompNbits;

architecture Structurel of CompNbits is
Component CelluleType
    port (
--          Entrees
            A: in std_logic;
            B:  in std_logic;
            PPin: in std_logic;
            PGin: in std_logic;
            EGin: in std_logic;
--          Sorties
            PPout: out std_logic;
            PGout: out std_logic;
            EGout: out std_logic);
end Component;

-- Signaux intercellules : Information transmise de cellule a cellule 3 signaux donc 3 carry
signal carry_PP : std_logic_vector (N downto 0);
signal carry_PG : std_logic_vector (N downto 0);
signal carry_EG : std_logic_vector (N downto 0);

begin


--Boucle de connexion du circuit iteratif
-- i : iterateur allant de N-1 a 0 (soit 3 a 0)
CircuitComplet : for i in N-1 downto 0  GENERATE
    Cellule_i : CelluleType port map (
                        A  => A(i),
                        B  => B(i),
                       PPin => carry_PP(i+1),
                              PGin => carry_PG(i+1),
                              EGin => carry_EG(i+1),
                       PPout => carry_PP(i),
                              PGout => carry_PG(i),
                              EGout => carry_EG(i)
                              );

end GENERATE;

--Assignation des conditions aux limites (Initialisation de la cellule MSB)
carry_PP(N) <= '0';
carry_PG(N) <= '0';
carry_EG(N) <= '0';

--Assignation des sorties du circuit complet
PP <= carry_PP(0);
PG <= carry_PG(0);
EG <= carry_EG(0);
end Structurel;
