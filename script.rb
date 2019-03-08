# ESSAS TRÊS CONDIÇÕES TÊM QUE OCORRER NO MESMO INSTANTE E DURAR NO MÍNIMO 4 HORAS
	# Velocidade do vento acima de 4m/s
	# Direção do vento com ângulo entre 300º e 30º: 
	# Temperatura acima de 90% da média de temperaturas do período
require "csv"
dataset = []
# Seleciono todos arquivos CSV na pasta datasets
`ls datasets/*.csv`.each_line do |line|
	# Salvo o arquivo CSV em um array de hashes
	CSV.foreach("#{`pwd`.chomp}/#{line.chomp}", col_sep: ',', row_sep: :auto, headers: true) do |row|
		dataset << { codigo_estacao: row['codigo_estacao'], data: row['data'], hora: row['hora'].to_i, temp_inst: row['temp_inst'].to_f, temp_max: row['temp_max'].to_f, temp_min: row['temp_min'].to_f, umid_inst: row['umid_inst'].to_f, umid_max: row['umid_max'].to_f, umid_min: row['umid_min'].to_f, pto_orvalho_inst: row['pto_orvalho_inst'].to_f, pto_orvalho_max: row['pto_orvalho_max'].to_f, pto_orvalho_min: row['pto_orvalho_min'].to_f, pressao: row['pressao'].to_f, pressao_max: row['pressao_max'].to_f, pressao_min: row['pressao_min'].to_f, vento_direcao: row['vento_direcao'].to_f, vento_vel: row['vento_vel'].to_f, vento_rajada: row['vento_rajada'].to_f, radiacao: row['radiacao'].to_f, precipitacao: row['precipitacao'].to_f }
	end
end
# As ocorrências possuem valores aleatórios no campo 'hora'. Por isso, eu substituo tal valor considerando que cada dia possui 24 medições feitas de hora em hora
for count in 0..dataset.size - 1 do
	if dataset.first == dataset[count] or dataset[count - 1] and dataset[count][:data] != dataset[count - 1][:data]
		24.times do |count_two|
			if dataset[count + count_two]
				dataset[count + count_two][:hora] = count_two
			end
		end
	end
end
average_temperature = 0
dataset.each do |row|
	average_temperature += row[:temp_inst]
end
average_temperature = average_temperature / dataset.size
occurrences_of_interest = []
dataset.each do |row|
	if row[:vento_vel] > 4 and row[:vento_direcao] >= 30 and row[:vento_direcao] <= 300 and row[:temp_inst] > average_temperature * 0.9
		occurrences_of_interest << row
	end
end
last_occurrence = occurrences_of_interest.first
puts "Temperatura média: #{average_temperature}ºC"
puts "\nOcorrência de vento norte nos instantes abaixo:\n\n"
for count in 0..occurrences_of_interest.size - 1 do
	if occurrences_of_interest[count + 3] and (occurrences_of_interest[count + 1][:data] == occurrences_of_interest[count][:data] and occurrences_of_interest[count + 2][:data] == occurrences_of_interest[count][:data] and occurrences_of_interest[count + 3][:data] == occurrences_of_interest[count][:data])
		if occurrences_of_interest[count][:hora] + 1 == occurrences_of_interest[count + 1][:hora] and occurrences_of_interest[count][:hora] + 2 == occurrences_of_interest[count + 2][:hora] and occurrences_of_interest[count][:hora] + 3 == occurrences_of_interest[count + 3][:hora]
			puts "Dia #{occurrences_of_interest[count + 0][:data]} às #{occurrences_of_interest[count + 0][:hora]}hrs: Velocidade: #{occurrences_of_interest[count + 0][:vento_vel]} - Direção: #{occurrences_of_interest[count + 0][:vento_direcao]}º - Temperatura: #{occurrences_of_interest[count + 0][:temp_inst]}"
			puts "Dia #{occurrences_of_interest[count + 1][:data]} às #{occurrences_of_interest[count + 1][:hora]}hrs: Velocidade: #{occurrences_of_interest[count + 1][:vento_vel]} - Direção: #{occurrences_of_interest[count + 1][:vento_direcao]}º - Temperatura: #{occurrences_of_interest[count + 1][:temp_inst]}"
			puts "Dia #{occurrences_of_interest[count + 2][:data]} às #{occurrences_of_interest[count + 2][:hora]}hrs: Velocidade: #{occurrences_of_interest[count + 2][:vento_vel]} - Direção: #{occurrences_of_interest[count + 2][:vento_direcao]}º - Temperatura: #{occurrences_of_interest[count + 2][:temp_inst]}"
			puts "Dia #{occurrences_of_interest[count + 3][:data]} às #{occurrences_of_interest[count + 3][:hora]}hrs: Velocidade: #{occurrences_of_interest[count + 3][:vento_vel]} - Direção: #{occurrences_of_interest[count + 3][:vento_direcao]}º - Temperatura: #{occurrences_of_interest[count + 3][:temp_inst]}"
			puts "\n\n"
		end
	end
end
