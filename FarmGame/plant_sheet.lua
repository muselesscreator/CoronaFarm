--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:89069f246ac362721ebdb9e0b94e48da:054545f53a2d61e26805050b77345b25:83fa3983fe0dfcdf42522ae32333b603$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- arrow-left
            x=1847,
            y=641,
            width=31,
            height=52,

        },
        {
            -- arrow-right
            x=1558,
            y=409,
            width=31,
            height=52,

        },
        {
            -- barren
            x=1344,
            y=2,
            width=157,
            height=151,

            sourceX = 3,
            sourceY = 0,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- bird00
            x=451,
            y=582,
            width=11,
            height=6,

        },
        {
            -- bird01
            x=1360,
            y=536,
            width=6,
            height=4,

            sourceX = 160,
            sourceY = 647,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird02
            x=1192,
            y=368,
            width=38,
            height=20,

            sourceX = 144,
            sourceY = 647,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird03
            x=1986,
            y=619,
            width=32,
            height=26,

            sourceX = 159,
            sourceY = 652,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird04
            x=1192,
            y=348,
            width=54,
            height=18,

            sourceX = 187,
            sourceY = 660,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird05
            x=1872,
            y=698,
            width=34,
            height=28,

            sourceX = 238,
            sourceY = 654,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird06
            x=1161,
            y=600,
            width=38,
            height=22,

            sourceX = 251,
            sourceY = 643,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird07
            x=1647,
            y=655,
            width=12,
            height=6,

            sourceX = 260,
            sourceY = 643,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird08
            x=1791,
            y=225,
            width=22,
            height=12,

            sourceX = 238,
            sourceY = 631,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird09
            x=1735,
            y=330,
            width=40,
            height=22,

            sourceX = 198,
            sourceY = 624,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- bird10
            x=451,
            y=725,
            width=18,
            height=16,

            sourceX = 166,
            sourceY = 633,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead01
            x=626,
            y=536,
            width=150,
            height=60,

            sourceX = 131,
            sourceY = 0,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead02
            x=464,
            y=536,
            width=160,
            height=56,

            sourceX = 125,
            sourceY = 14,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead03
            x=1503,
            y=149,
            width=162,
            height=40,

            sourceX = 113,
            sourceY = 18,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead04
            x=744,
            y=224,
            width=166,
            height=52,

            sourceX = 101,
            sourceY = 26,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead05
            x=782,
            y=426,
            width=146,
            height=72,

            sourceX = 122,
            sourceY = 41,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead06
            x=1791,
            y=252,
            width=128,
            height=100,

            sourceX = 157,
            sourceY = 83,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead07
            x=1205,
            y=393,
            width=40,
            height=172,

            sourceX = 273,
            sourceY = 98,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead08
            x=740,
            y=290,
            width=40,
            height=204,

            sourceX = 291,
            sourceY = 72,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead09
            x=1161,
            y=400,
            width=42,
            height=198,

            sourceX = 286,
            sourceY = 72,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead10
            x=1192,
            y=2,
            width=62,
            height=344,

            sourceX = 285,
            sourceY = 105,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead11
            x=1256,
            y=2,
            width=86,
            height=288,

            sourceX = 257,
            sourceY = 70,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead12
            x=1192,
            y=2,
            width=62,
            height=344,

            sourceX = 285,
            sourceY = 105,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead13
            x=1136,
            y=2,
            width=54,
            height=396,

            sourceX = 302,
            sourceY = 169,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead14
            x=952,
            y=2,
            width=94,
            height=358,

            sourceX = 292,
            sourceY = 203,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- birdDead15
            x=1048,
            y=2,
            width=86,
            height=354,

            sourceX = 293,
            sourceY = 214,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- blank
            x=931,
            y=495,
            width=125,
            height=125,

            sourceX = 25,
            sourceY = 25,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- boxClosed
            x=1801,
            y=2,
            width=143,
            height=145,

        },
        {
            -- boxOpen
            x=1656,
            y=2,
            width=143,
            height=145,

        },
        {
            -- carrot01
            x=1745,
            y=648,
            width=51,
            height=87,

            sourceX = 57,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- carrot02
            x=930,
            y=362,
            width=123,
            height=131,

            sourceX = 31,
            sourceY = 14,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- carrot03
            x=1344,
            y=155,
            width=145,
            height=143,

            sourceX = 25,
            sourceY = 0,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- carrot04
            x=778,
            y=500,
            width=151,
            height=87,

            sourceX = 15,
            sourceY = 76,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- carrotIcon
            x=1205,
            y=567,
            width=40,
            height=40,

        },
        {
            -- celery01
            x=922,
            y=302,
            width=27,
            height=53,

            sourceX = 79,
            sourceY = 93,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- celery02
            x=1854,
            y=354,
            width=61,
            height=113,

            sourceX = 55,
            sourceY = 33,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- celery03
            x=600,
            y=598,
            width=71,
            height=143,

            sourceX = 48,
            sourceY = 4,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- celery04
            x=1946,
            y=2,
            width=73,
            height=139,

            sourceX = 70,
            sourceY = 8,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- celeryIcon
            x=922,
            y=264,
            width=28,
            height=36,

            sourceX = 2,
            sourceY = 1,
            sourceWidth = 40,
            sourceHeight = 40
        },
        {
            -- chamomile01
            x=1840,
            y=469,
            width=63,
            height=51,

            sourceX = 64,
            sourceY = 92,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- chamomile02
            x=1558,
            y=463,
            width=87,
            height=105,

            sourceX = 48,
            sourceY = 37,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- chamomile03
            x=1921,
            y=278,
            width=97,
            height=113,

            sourceX = 38,
            sourceY = 29,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- chamomile04
            x=1647,
            y=457,
            width=81,
            height=101,

            sourceX = 49,
            sourceY = 41,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- chamomileIcon
            x=1798,
            y=704,
            width=36,
            height=34,

            sourceX = 2,
            sourceY = 3,
            sourceWidth = 40,
            sourceHeight = 40
        },
        {
            -- gopher
            x=1644,
            y=330,
            width=89,
            height=125,

            sourceX = 48,
            sourceY = 18,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- gopher01
            x=1392,
            y=619,
            width=81,
            height=109,

            sourceX = 50,
            sourceY = 30,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- gopher02
            x=1946,
            y=143,
            width=73,
            height=133,

            sourceX = 54,
            sourceY = 42,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- gopher03
            x=1313,
            y=619,
            width=77,
            height=111,

            sourceX = 52,
            sourceY = 64,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- gopher04
            x=1880,
            y=611,
            width=57,
            height=49,

            sourceX = 60,
            sourceY = 89,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- gopherDie01
            x=1228,
            y=619,
            width=83,
            height=117,

            sourceX = 52,
            sourceY = 22,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- gopherDie02
            x=1131,
            y=624,
            width=95,
            height=117,

            sourceX = 56,
            sourceY = 28,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- gopherDie03
            x=1472,
            y=310,
            width=117,
            height=97,

            sourceX = 58,
            sourceY = 50,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- gopherDie04
            x=1735,
            y=354,
            width=117,
            height=87,

            sourceX = 58,
            sourceY = 54,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- jalapenoIcon
            x=1880,
            y=662,
            width=34,
            height=34,

            sourceX = 3,
            sourceY = 2,
            sourceWidth = 40,
            sourceHeight = 40
        },
        {
            -- jalapenos01
            x=1833,
            y=522,
            width=53,
            height=77,

            sourceX = 55,
            sourceY = 81,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- jalapenos02
            x=1058,
            y=487,
            width=101,
            height=135,

            sourceX = 31,
            sourceY = 22,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- jalapenos03
            x=308,
            y=582,
            width=141,
            height=157,

            sourceX = 18,
            sourceY = 2,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- jalapenos04
            x=790,
            y=589,
            width=127,
            height=137,

            sourceX = 15,
            sourceY = 23,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- lettuce01
            x=1888,
            y=544,
            width=57,
            height=65,

            sourceX = 55,
            sourceY = 76,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- lettuce02
            x=1566,
            y=570,
            width=79,
            height=91,

            sourceX = 41,
            sourceY = 50,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- lettuce03
            x=1256,
            y=292,
            width=85,
            height=113,

            sourceX = 37,
            sourceY = 28,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- lettuce04
            x=1815,
            y=149,
            width=129,
            height=101,

            sourceX = 23,
            sourceY = 51,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- lettuceIcon
            x=1836,
            y=704,
            width=34,
            height=32,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 40,
            sourceHeight = 40
        },
        {
            -- mallet
            x=1360,
            y=397,
            width=83,
            height=137,

            sourceX = 31,
            sourceY = 22,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mint01
            x=1722,
            y=599,
            width=73,
            height=47,

            sourceX = 55,
            sourceY = 87,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mint02
            x=1030,
            y=624,
            width=99,
            height=117,

            sourceX = 39,
            sourceY = 17,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mint03
            x=1247,
            y=407,
            width=111,
            height=133,

            sourceX = 28,
            sourceY = 8,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mint04
            x=919,
            y=622,
            width=109,
            height=119,

            sourceX = 29,
            sourceY = 17,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- mintIcon
            x=1833,
            y=601,
            width=32,
            height=38,

            sourceX = 3,
            sourceY = 0,
            sourceWidth = 40,
            sourceHeight = 40
        },
        {
            -- potatoIcon
            x=912,
            y=224,
            width=38,
            height=38,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 40,
            sourceHeight = 40
        },
        {
            -- potatoes01
            x=1947,
            y=544,
            width=55,
            height=73,

            sourceX = 50,
            sourceY = 55,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- potatoes02
            x=1475,
            y=605,
            width=89,
            height=129,

            sourceX = 34,
            sourceY = 10,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- potatoes03
            x=1503,
            y=2,
            width=151,
            height=145,

            sourceX = 8,
            sourceY = 1,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- potatoes04
            x=1343,
            y=300,
            width=127,
            height=95,

            sourceX = 24,
            sourceY = 49,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- pumpkin01
            x=782,
            y=278,
            width=138,
            height=146,

            sourceX = 110,
            sourceY = 96,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- pumpkin02
            x=744,
            y=2,
            width=206,
            height=220,

            sourceX = 51,
            sourceY = 48,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- pumpkin03
            x=464,
            y=2,
            width=278,
            height=286,

            sourceX = 1,
            sourceY = 3,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- pumpkin04
            x=464,
            y=290,
            width=274,
            height=244,

            sourceX = 9,
            sourceY = 42,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- radish01
            x=1798,
            y=641,
            width=47,
            height=61,

            sourceX = 53,
            sourceY = 65,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- radish02
            x=1647,
            y=560,
            width=73,
            height=93,

            sourceX = 44,
            sourceY = 36,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- radish03
            x=451,
            y=594,
            width=147,
            height=129,

            sourceX = 13,
            sourceY = 0,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- radish04
            x=1491,
            y=191,
            width=151,
            height=117,

            sourceX = 21,
            sourceY = 51,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- radishIcon
            x=1797,
            y=599,
            width=34,
            height=40,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 40,
            sourceHeight = 40
        },
        {
            -- rock
            x=1445,
            y=409,
            width=111,
            height=109,

            sourceX = 28,
            sourceY = 42,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- scoreStar
            x=1939,
            y=619,
            width=45,
            height=45,

        },
        {
            -- seeds
            x=1455,
            y=520,
            width=101,
            height=83,

            sourceX = 37,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- slingshot
            x=1055,
            y=358,
            width=79,
            height=127,

            sourceX = 52,
            sourceY = 24,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- smell01
            x=1354,
            y=542,
            width=99,
            height=75,

            sourceX = 34,
            sourceY = 15,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- smell02
            x=1247,
            y=542,
            width=105,
            height=75,

            sourceX = 32,
            sourceY = 15,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- smell03
            x=1735,
            y=443,
            width=103,
            height=77,

            sourceX = 33,
            sourceY = 13,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- smell04
            x=1730,
            y=522,
            width=101,
            height=75,

            sourceX = 34,
            sourceY = 14,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- stage00
            x=673,
            y=598,
            width=115,
            height=139,

            sourceX = 53,
            sourceY = 16,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- swoop01
            x=2,
            y=2,
            width=228,
            height=582,

            sourceX = 10,
            sourceY = 16,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- swoop02
            x=1566,
            y=663,
            width=96,
            height=78,

            sourceX = 137,
            sourceY = 523,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- swoop03
            x=1917,
            y=393,
            width=102,
            height=92,

            sourceX = 154,
            sourceY = 525,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- swoop04
            x=1566,
            y=663,
            width=96,
            height=78,

            sourceX = 137,
            sourceY = 523,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- swoop05
            x=1667,
            y=149,
            width=146,
            height=74,

            sourceX = 143,
            sourceY = 525,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- swoop06
            x=232,
            y=2,
            width=230,
            height=578,

            sourceX = 202,
            sourceY = 5,
            sourceWidth = 440,
            sourceHeight = 700
        },
        {
            -- tag
            x=1591,
            y=310,
            width=51,
            height=135,

            sourceX = 114,
            sourceY = 10,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- tomatos01
            x=1664,
            y=655,
            width=79,
            height=81,

            sourceX = 49,
            sourceY = 75,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- tomatos02
            x=163,
            y=586,
            width=143,
            height=155,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- tomatos03
            x=2,
            y=586,
            width=159,
            height=155,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- tomatos04
            x=1644,
            y=225,
            width=145,
            height=103,

            sourceX = 10,
            sourceY = 56,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- tomatosIcon
            x=740,
            y=496,
            width=36,
            height=36,

            sourceX = 2,
            sourceY = 1,
            sourceWidth = 40,
            sourceHeight = 40
        },
        {
            -- tutorialHand
            x=1905,
            y=487,
            width=99,
            height=55,

        },
    },
    
    sheetContentWidth = 2021,
    sheetContentHeight = 743
}

SheetInfo.frameIndex =
{

    ["arrow-left"] = 1,
    ["arrow-right"] = 2,
    ["barren"] = 3,
    ["bird00"] = 4,
    ["bird01"] = 5,
    ["bird02"] = 6,
    ["bird03"] = 7,
    ["bird04"] = 8,
    ["bird05"] = 9,
    ["bird06"] = 10,
    ["bird07"] = 11,
    ["bird08"] = 12,
    ["bird09"] = 13,
    ["bird10"] = 14,
    ["birdDead01"] = 15,
    ["birdDead02"] = 16,
    ["birdDead03"] = 17,
    ["birdDead04"] = 18,
    ["birdDead05"] = 19,
    ["birdDead06"] = 20,
    ["birdDead07"] = 21,
    ["birdDead08"] = 22,
    ["birdDead09"] = 23,
    ["birdDead10"] = 24,
    ["birdDead11"] = 25,
    ["birdDead12"] = 26,
    ["birdDead13"] = 27,
    ["birdDead14"] = 28,
    ["birdDead15"] = 29,
    ["blank"] = 30,
    ["boxClosed"] = 31,
    ["boxOpen"] = 32,
    ["carrot01"] = 33,
    ["carrot02"] = 34,
    ["carrot03"] = 35,
    ["carrot04"] = 36,
    ["carrotIcon"] = 37,
    ["celery01"] = 38,
    ["celery02"] = 39,
    ["celery03"] = 40,
    ["celery04"] = 41,
    ["celeryIcon"] = 42,
    ["chamomile01"] = 43,
    ["chamomile02"] = 44,
    ["chamomile03"] = 45,
    ["chamomile04"] = 46,
    ["chamomileIcon"] = 47,
    ["gopher"] = 48,
    ["gopher01"] = 49,
    ["gopher02"] = 50,
    ["gopher03"] = 51,
    ["gopher04"] = 52,
    ["gopherDie01"] = 53,
    ["gopherDie02"] = 54,
    ["gopherDie03"] = 55,
    ["gopherDie04"] = 56,
    ["jalapenoIcon"] = 57,
    ["jalapenos01"] = 58,
    ["jalapenos02"] = 59,
    ["jalapenos03"] = 60,
    ["jalapenos04"] = 61,
    ["lettuce01"] = 62,
    ["lettuce02"] = 63,
    ["lettuce03"] = 64,
    ["lettuce04"] = 65,
    ["lettuceIcon"] = 66,
    ["mallet"] = 67,
    ["mint01"] = 68,
    ["mint02"] = 69,
    ["mint03"] = 70,
    ["mint04"] = 71,
    ["mintIcon"] = 72,
    ["potatoIcon"] = 73,
    ["potatoes01"] = 74,
    ["potatoes02"] = 75,
    ["potatoes03"] = 76,
    ["potatoes04"] = 77,
    ["pumpkin01"] = 78,
    ["pumpkin02"] = 79,
    ["pumpkin03"] = 80,
    ["pumpkin04"] = 81,
    ["radish01"] = 82,
    ["radish02"] = 83,
    ["radish03"] = 84,
    ["radish04"] = 85,
    ["radishIcon"] = 86,
    ["rock"] = 87,
    ["scoreStar"] = 88,
    ["seeds"] = 89,
    ["slingshot"] = 90,
    ["smell01"] = 91,
    ["smell02"] = 92,
    ["smell03"] = 93,
    ["smell04"] = 94,
    ["stage00"] = 95,
    ["swoop01"] = 96,
    ["swoop02"] = 97,
    ["swoop03"] = 98,
    ["swoop04"] = 99,
    ["swoop05"] = 100,
    ["swoop06"] = 101,
    ["tag"] = 102,
    ["tomatos01"] = 103,
    ["tomatos02"] = 104,
    ["tomatos03"] = 105,
    ["tomatos04"] = 106,
    ["tomatosIcon"] = 107,
    ["tutorialHand"] = 108,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
