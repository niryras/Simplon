#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 10:15:13 2020

@author: simplon
"""
from sqlalchemy import create_engine
engine1 = create_engine('mysql+mysqlconnector://simplon:TPR2511box?@localhost:3306/simplon')


import pandas as pd
from datetime import date
frame = pd.read_sql_query('SELECT * FROM simplon.jeux_video;', engine1)
print(frame)


engine2 = create_engine('mysql+mysqlconnector://simplon:TPR2511box?@localhost:3306/assur_auto')

data = pd.read_sql_query('select * from clients', engine2)
print(data)

CL_ID=pd.read_sql_query('select max(CL_ID) from clients;',engine2)
CL_ID=CL_ID.iloc[0,0]
if CL_ID==None:
    CL_ID=0
CL_ID = CL_ID + 1    
CL_NOM=str.upper(input("Entrer le nom du client: "))
CL_PRENOM=str.capitalize(input("Entrer le prenom du client: "))
CL_ADRESSE=input("Entrer l'adresse du client: ")

CL_CODE_POSTAL=input("Entrer le code postal du client: ")

while not CL_CODE_POSTAL.isnumeric():
      print("Entrer un code postal contenant uniquement des chiffres")
      CL_CODE_POSTAL=input("Entrer le code postal du client: ")   
    
CL_VILLE=input("Entrer la ville du domicile du client: ")
CL_COORDONNEES=input("Entrer les coordonnees du client: ")

engine2.execute('INSERT INTO clients (CL_ID,CL_NOM,CL_PRENOM,CL_ADRESSE, CL_CODE_POSTAL, CL_VILLE, CL_COORDONNEES) VALUES (%s,"%s","%s","%s","%s","%s","%s");'%(CL_ID,CL_NOM,CL_PRENOM,CL_ADRESSE, CL_CODE_POSTAL, CL_VILLE, CL_COORDONNEES))


CO_NUM=pd.read_sql_query('select max(CO_NUM) from contrat;',engine2)
CO_NUM=CO_NUM.iloc[0,0]
if CO_NUM==None:
    CO_NUM=0
CO_NUM=CO_NUM + 1
CO_DATE=date.today()
CO_CATEGORIE=input("Entrer la categorie du contrat: ")
CL_ID_FK=CL_ID

engine2.execute ('INSERT INTO contrat (CO_NUM, CO_DATE, CO_CATEGORIE, CL_ID_FK) VALUES(%s,"%s","%s",%s);'%(CO_NUM, CO_DATE, CO_CATEGORIE, CL_ID_FK))

data2 = pd.read_sql_query('select * from contrat', engine2)
print(data2)