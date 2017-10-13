---
navhome: /docs/
---


### `++glam`

Galaxy names

Retrieves the 'name' of a given Galaxy.

Accepts
-------

`zar` is a `@p` of one byte, the length of a Galaxy name.

Source
------

    ++  glam
      |=  zar=@pD  ^-  tape
      %+  snag  zar
      ^-  (list tape)
      :~  "Tianming"  "Pepin the Short"  "Haile Selassie"  "Alfred the Great"
          "Tamerlane"  "Pericles"  "Talleyrand"  "Yongle"  "Seleucus"
          "Uther Pendragon"  "Louis XVI"  "Ahmad Shāh Durrānī"  "Constantine"
          "Wilhelm I"  "Akbar"  "Louis XIV"  "Nobunaga"  "Alexander VI"
          "Philippe II"  "Julius II"  "David"  "Niall Noígíallach"  "Kublai Khan"
          "Öz Beg Khan"  "Ozymandias"  "Ögedei Khan"  "Jiang Jieshi"  "Darius"
          "Shivaji"  "Qianlong"  "Bolesław I Chrobry"  "Tigranes"  "Han Wudi"
          "Charles X"  "Naresuan"  "Frederick II"  "Simeon"  "Kangxi"
          "Suleiman the Magnificent"  "Pedro II"  "Genghis Khan"  "Laozi"
          "Porfirio Díaz"  "Pakal"  "Wu Zetian"  "Garibaldi"  "Matthias Corvinus"
          "Leopold II"  "Leonidas"  "Sitting Bull"  "Nebuchadnezzar II"
          "Rhodes"  "Henry VIII"  "Attila"  "Catherine II"  "Chulalongkorn"
          "Uthmān"  "Augustus"  "Faustin"  "Chongde"  "Justinian"
          "Afonso de Albuquerque"  "Antoninus Pius"  "Cromwell"  "Innocent X"
          "Fidel"  "Frederick the Great"  "Canute"  "Vytautas"  "Amina"
          "Hammurabi"  "Suharto"  "Victoria"  "Hiawatha"  "Paul V"  "Shaka"
          "Lê Thánh Tông"  "Ivan Asen II"  "Tiridates"  "Nefertiti"  "Gwangmu"
          "Ferdinand & Isabella"  "Askia"  "Xuande"  "Boris Godunov"  "Gilgamesh"
          "Maximillian I"  "Mao"  "Charlemagne"  "Narai"  "Hanno"  "Charles I & V"
          "Alexander II"  "Mansa Musa"  "Zoe Porphyrogenita"  "Metternich"
          "Robert the Bruce"  "Pachacutec"  "Jefferson"  "Solomon"  "Nicholas I"
          "Barbarossa"  "FDR"  "Pius X"  "Gwanggaeto"  "Abbas I"  "Julius Caesar"
          "Lee Kuan Yew"  "Ranavalona I"  "Go-Daigo"  "Zenobia"  "Henry V"
          "Bảo Đại"  "Casimir III"  "Cyrus"  "Charles the Wise"  "Sandrokottos"
          "Agamemnon"  "Clement VII"  "Suppiluliuma"  "Deng Xiaoping"
          "Victor Emmanuel"  "Ajatasatru"  "Jan Sobieski"  "Huangdi"  "Xuantong"
          "Narmer"  "Cosimo de' Medici"  "Möngke Khan"  "Stephen Dušan"  "Henri IV"
          "Mehmed Fatih"  "Conn Cétchathach"  "Francisco Franco"  "Leo X"
          "Kammu"  "Krishnadevaraya"  "Elizabeth I"  "Norton I"  "Washington"
          "Meiji"  "Umar"  "TR"  "Peter the Great"  "Agustin I"  "Ashoka"
          "William the Conqueror"  "Kongolo Mwamba"  "Song Taizu"
          "Ivan the Terrible"  "Yao"  "Vercingetorix"  "Geronimo"  "Rurik"
          "Urban VIII"  "Alexios Komnenos"  "Maria I"  "Tamar"  "Bismarck"
          "Arthur"  "Jimmu"  "Gustavus Adolphus"  "Suiko"  "Basil I"  "Montezuma"
          "Santa Anna"  "Xerxes"  "Beyazıt Yıldırım"  "Samudragupta"  "James I"
          "George III"  "Kamehameha"  "Francesco Sforza"  "Trajan"
          "Rajendra Chola"  "Hideyoshi"  "Cleopatra"  "Alexander"
          "Ashurbanipal"  "Paul III"  "Vespasian"  "Tecumseh"  "Narasimhavarman"
          "Suryavarman II"  "Bokassa I"  "Charles Canning"  "Theodosius"
          "Francis II"  "Zhou Wen"  "William Jardine"  "Ahmad al-Mansur"
          "Lajos Nagy"  "Theodora"  "Mussolini"  "Samuil"  "Osman Gazi"
          "Kim Il-sung"  "Maria Theresa"  "Lenin"  "Tokugawa"  "Marcus Aurelius"
          "Nzinga Mbande"  "Edward III"  "Joseph II"  "Pulakesi II"  "Priam"
          "Qin Shi Huang"  "Shah Jahan"  "Sejong"  "Sui Wendi"  "Otto I"
          "Napoleon III"  "Prester John"  "Dido"  "Joao I"  "Gregory I"
          "Gajah Mada"  "Abd-ar Rahmān III"  "Taizong"  "Franz Josef I"
          "Nicholas II"  "Gandhi"  "Chandragupta II"  "Peter III"
          "Oba Ewuare"  "Louis IX"  "Napoleon"  "Selim Yavuz"  "Shun"
          "Hayam Wuruk"  "Jagiełło"  "Nicaule"  "Sargon"  "Saladin"  "Charles II"
          "Brian Boru"  "Da Yu"  "Antiochus III"  "Charles I"
          "Jan Pieterszoon Coen"  "Hongwu"  "Mithridates"  "Hadrian"  "Ptolemy"
          "Benito Juarez"  "Sun Yat-sen"  "Raja Raja Chola"  "Bolivar"  "Pius VII"
          "Shapur II"  "Taksin"  "Ram Khamhaeng"  "Hatshepsut"  "Alī"  "Matilda"
          "Ataturk"
      ==
    ::

Examples
--------

    ~zod/main=> (glam ~zod)
    "Tianming"
    ~zod/main=> (glam ~fyr)
    "Bolivar"


