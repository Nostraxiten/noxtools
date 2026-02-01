#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# NOX SEES YOU: OSINT & PHONE INTELLIGENCE - Optimized for noxtools

import os
import re
import requests
import time
from datetime import datetime

class PhoneOSINT:
    def __init__(self):
        self.active_numbers = []
        self.inactive_numbers = []
        self.results_file = "phone_scan_results.txt"
        self.session = requests.Session()
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8'
        }
        
    def clear_screen(self):
        os.system('cls' if os.name == 'nt' else 'clear')
    
    def print_banner(self):
        self.clear_screen()
        print("\033[91m" + "=" * 60)
        print("\033[1;37m" + "   NOX SEES YOU - THE EYE IS OPEN (noxtools)" + "\033[0m")
        print("\033[91m" + "=" * 60 + "\033[0m")
        print("  OSINT & Phone Intelligence Tool - Python Edition")
        print("=" * 60 + "\n")
    
    def clean_phone_number(self, phone_input):
        cleaned = re.sub(r'[^\d+]', '', phone_input)
        if not cleaned.startswith('+'):
            print("\n\033[33m[!] Sin código de país (+xx)\033[0m")
            choice = input("¿Agregar prefijo? (s/n): ").lower()
            if choice == 's':
                prefix = input("Prefijo (ej: 34): ").replace('+', '')
                cleaned = f"+{prefix}{cleaned}"
            else:
                cleaned = f"+34{cleaned}"
        return cleaned[:16]
    
    def identify_country_and_type(self, phone_number):
        country_codes = {'1': 'USA/CA', '34': 'España', '33': 'Francia', '44': 'UK', '49': 'Alemania', '52': 'México', '54': 'Argentina', '57': 'Colombia'}
        clean = phone_number[1:]
        country, line_type, country_code = 'Desconocido', 'No identificado', ''
        
        for length in [3, 2, 1]:
            code = clean[:length]
            if code in country_codes:
                country = country_codes[code]
                country_code = code
                break
        
        if country_code == '34':
            first = clean[2:3]
            line_type = "Móvil" if first in ['6', '7'] else "Fijo" if first in ['8', '9'] else "Especial"
        return country, line_type, country_code
    
    def check_whatsapp_status(self, phone_number):
        clean_number = phone_number[1:]
        wa_url = f"https://api.whatsapp.com/send/?phone={clean_number}"
        try:
            # WhatsApp redirige o muestra un botón de 'Chat' si existe
            response = self.session.get(wa_url, headers=self.headers, timeout=10)
            content = response.text
            # Si el número no existe, WA suele mostrar "El número de teléfono no es válido" o similar
            invalid_patterns = ['phone_number_invalid', 'invalid number', 'no es válido']
            if any(p in content.lower() for p in invalid_patterns):
                return False, wa_url
            return response.status_code == 200, wa_url
        except Exception:
            return False, wa_url
    
    def generate_search_links(self, phone_number):
        num = phone_number[1:]
        return {
            "Google": f"https://www.google.com/search?q=%22{num}%22",
            "Truecaller": f"https://www.truecaller.com/search/intl/{phone_number}",
            "Sync.me": f"https://sync.me/search/?number={num}",
            "Facebook": f"https://www.facebook.com/search/top/?q={num}"
        }
    
    def save_to_list(self, phone_number, is_active, country, line_type):
        result = {"phone": phone_number, "country": country, "type": line_type, 
                  "timestamp": datetime.now().strftime("%H:%M:%S"), "status": "ACTIVO" if is_active else "INACTIVO"}
        if is_active: self.active_numbers.append(result)
        else: self.inactive_numbers.append(result)
        print(f"\033[32m[+] Guardado como {result['status']}\033[0m")
    
    def export_results(self):
        if not self.active_numbers and not self.inactive_numbers: return
        with open(self.results_file, 'w', encoding='utf-8') as f:
            f.write(f"NOX SEES YOU - {datetime.now()}\n" + "="*30 + "\n")
            for cat, data in [("ACTIVOS", self.active_numbers), ("INACTIVOS", self.inactive_numbers)]:
                f.write(f"\n--- {cat} ---\n")
                for n in data: f.write(f"{n['phone']} | {n['country']} | {n['type']}\n")
        print(f"\n\033[32m[+] Exportado a {self.results_file}\033[0m")

    def scan_phone(self, phone_input):
        phone = self.clean_phone_number(phone_input)
        country, l_type, _ = self.identify_country_and_type(phone)
        active, url = self.check_whatsapp_status(phone)
        
        print(f"\n\033[1;36mRESULTADOS:\033[0m\n > Número: {phone}\n > País: {country}\n > Tipo: {l_type}")
        print(f" > WhatsApp: {'\033[32mACTIVO ✓' if active else '\033[31mINACTIVO ✗'}\033[0m")
        
        links = self.generate_search_links(phone)
        for name, l_url in links.items(): print(f" > {name}: \033[34m{l_url}\033[0m")
        
        if input("\n¿Guardar? (s/n): ").lower() == 's':
            self.save_to_list(phone, active, country, l_type)

    def run(self):
        while True:
            self.print_banner()
            print("1. Escanear número\n2. Escaneo por lote\n3. Ver listas\n4. Exportar\n5. Limpiar\n6. Salir")
            op = input("\nOpción: ")
            if op == '1': self.scan_phone(input("Número: "))
            elif op == '2': 
                path = input("Archivo: ")
                if os.path.exists(path):
                    with open(path) as f:
                        for n in f: self.scan_phone(n.strip()); time.sleep(1)
            elif op == '3':
                for i, n in enumerate(self.active_numbers + self.inactive_numbers): print(f"{i}. {n['phone']} [{n['status']}]")
                input("\nPresiona Enter...")
            elif op == '4': self.export_results()
            elif op == '5': self.active_numbers, self.inactive_numbers = [], []
            elif op == '6': break

if __name__ == "__main__":
    try:
        PhoneOSINT().run()
    except KeyboardInterrupt:
        print("\nBye.")

