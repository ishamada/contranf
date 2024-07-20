import csv
import os

# Define the expected structure and file extensions
expected_structure = {
    "target": ".bed",
    "sample": ".bam",
    "control": ".bam",
    "reference": ".fasta",
    "output_dir": None  # No extension check for directories
}

def validate_csv(file_path):
    with open(file_path, mode='r') as file:
        reader = csv.reader(file)
        header = next(reader)
        
        # Check header
        if header != ["param", "path"]:
            print("Invalid header")
            return False
        
        # Check rows
        for row in reader:
            if len(row) != 2:
                print(f"Invalid row length: {row}")
                return False
            
            param, path = row
            if param not in expected_structure:
                print(f"Unexpected parameter: {param}")
                return False
            
            expected_extension = expected_structure[param]
            if expected_extension and not path.endswith(expected_extension):
                print(f"Invalid file extension for {param}: {path}")
                return False
            
            # Check if path is valid for output_dir without checking existence
            if param == "output_dir" and not os.path.isabs(path):
                print(f"Invalid path for output_dir: {path}")
                return False
        
        # print("CSV file is valid")
        return True

# Example usage
file_path = '/home/islam/contranf/samplesheet.csv'
func_res = validate_csv(file_path)
print(func_res)