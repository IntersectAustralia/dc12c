class AddPartyTable < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :title, limit: 10
      t.string :given_name, limit: 50
      t.string :family_name, limit: 50
      t.string :email, limit: 100
      t.string :description, limit: 2000

      t.string :homepage, limit: 250
      t.string :nla_identifier, limit: 200
      t.string :for_codes, limit: 40

      t.timestamps
    end
    party_hashes = [
      {
        title: 'Dr.',
        given_name: 'Trevor',
        family_name: 'Evans',
        email: 'trevor.evans@mq.edu.au',
        description: 'Trevor Evans is a Senior Lecturer in the Department of Ancient History, Faculty of Arts and member of the Ancient Cultures Research Centre at Macquarie University. He took his first degree at the University of New England (1985-91), focusing on ancient languages, and went on to pursue doctoral studies at the University of Sydney under the supervision of Dr John Lee (1992-7). The early years of his professional career were spent at Macquarie University as Research Officer (1998-2001) and later Macquarie University Research Fellow (2001-4). Transferring to the University of Oxford he worked as Assistant Editor of the Dictionary of Medieval Latin from British Sources (2004-7) and was also appointed Senior Golding Fellow at Brasenose College (2005-7). He returned to Macquarie in 2007 to take up a lectureship within the Department of Ancient History as a member of the Concentration of Research Excellence (CORE) in Ancient Cultures, and now teaches a range of Greek and Latin courses and convenes the Macquarie Ancient History Research Seminar. He has broad research interests in the history of the Greek and Latin languages within their changing cultural contexts, including the complex issues of linguistic diversity, multilingualism, and ancient literacy. A special focus is the history of the Greek language in the post-classical period (300BCE-600CE). He has published on the language of Greek and Latin papyri and related documents, the language of the Septuagint, and Greek and Latin lexicography.',
        homepage: 'http://www.mq.edu.au/about_us/faculties_and_departments/faculty_of_arts/department_of_ancient_history/staff/dr_trevor_evans/',
        nla_identifier: 'http://nla.gov.au/nla.party-549541',
        for_codes: '210306,200305,210105',
      },
      {
        title: 'Dr.',
        given_name: 'Malcolm',
        family_name: 'Choat',
        email: 'malcolm.choat@mq.edu.au',
        description: 'Dr Malcolm Choat is a Senior lecturer in the Department of Ancient History, and Secretary of the Macquarie University Ancient Cultures Research Centre. He studied Classics and Ancient History at the University of Queensland (1989-1993), before undertaking a PhD at Macquarie (1994-2000). Subsequently, he taught and researched in the School of Studies in Religion at the University of Sydney (2000-2002), before holding a Macquarie University Research Fellowship (2003-2006). He now teaches at Macquarie in Coptic Studies, Early Christianity, and Ptolemaic Egypt. His fields of research are, broadly, Graeco-Roman Egypt and the interaction of Classical (Greek and Roman) and Egyptian cultures from Alexander the Great to the Arab conquest (332 BCE - 642 CE), and early Christianity, particularly from a papyrological perspective. He has particular focuses on rise of the Coptic language and script in the3rd-5th centuries, especially early Coptic documents on papyrus, and the development of monasticism.',
        homepage: 'http://www.mq.edu.au/about_us/faculties_and_departments/faculty_of_arts/department_of_ancient_history/staff/dr_malcolm_choat/',
        for_codes: '210105,200305,210306,220401',
      },
      {
        title: 'Mr.',
        given_name: 'Karl',
        family_name: 'Van Dyke',
        email: 'karl.vandyke@mq.edu.au',
        description: 'Mr Karl Van Dyke is the Director of the Museum of Ancient Cultures at Macquarie University.  He studied Archaeology  at the University of Sydney (1972-1976), before  taking up a career as an Ancient History teacher. He has worked at Macquarie University since 1991 and has a strong interest in university museums and collections (UMACs), being a member of the Vice-Chancellor\'s  Advisory Committee on Macquarie\'s UMACs as well as part of the team that held national surveys of university museums and collections, culminating in two ground breaking publications, the Cinderella Collections. Karl spent a number of years as Vice-President and then as national President of CAUMAC, the Council of Australian University Museums and Collections, as it merged with Museums Australia. He also supported the establishment of the international UMAC movement as it became a part of ICOM in Paris, and has attended and given papers at a number of the interantional conferences. Karl has an on-going interest in archaeology, in material culture and the world of museums, and researches and publishes on aspects of the latter.',
        homepage: 'http://www.mac.mq.edu.au/',
        for_codes: '210105',
      },
    ]
    party_hashes.each do |attrs|
      Party.create!(attrs)
    end
  end

end
