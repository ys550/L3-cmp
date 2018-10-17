library IEEE;
use IEEE.std_logic_1164.all;
ENTITY CelluleType is
port    (
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
END CelluleType;

ARCHITECTURE LOGIC OF CelluleType IS
Begin
PPout <= ( not PGin and not EGin and not A and B) or ( not PGin and not EGin and PPin);
PGout <= ( not PGin and not A and B and not PPin) or (PGin and not EGin and not PPin);
EGout <= (not A and not B and not PGin and not PPin) or (A and B and not PGin and not PPin)or ( not PGin and EGin and not PPin);
END LOGIC;

