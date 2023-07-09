classdef Attack
    % The class Attack tries to decrypt a permutation-cipher encoded
    % message
    
    properties
        % A property ciphertext that stores the encrypted message
        ciphertext
        % A property key that stores a PermutationKey object
        key
        % A property past that stores appropriate "undo" information
        past
    end
    
    methods
        function obj = Attack(EncryptedMessage)
            % The Constructor Method: It takes an encrypted message as the
            % input, stores it as the ciphertext property, initialises
            % the key with the identity permutation 1:26 and stores
            % appropriate "undo" information in the past property
            obj.ciphertext = EncryptedMessage;
            obj.key=PermutationKey((1:26));
            obj.past=List([],[]);
        end
        function disp(obj)
            disp('PermutationKey:')
            disp(obj.key)
            disp(char(13))
            disp('Partial Decoding:')
            MinValue=min(length(obj.ciphertext),300);
            disp(decryption(obj.key,obj.ciphertext(1:MinValue)))
        end
        function Occurences=lettercount(obj)
            % A function that counts the occurences of each letter of the
            % alphabet in the ciphertext, and returns them as a 1x26 array
            % Setting a zeros vector for the Occurences of each letter
            Occurences=zeros(1,26);
            % Changing the object into a vector with the letters A to Z in
            % the range 1 to 26
            a=double(obj.ciphertext)-64;
            for i=1:26
                Occurences(i)=0;
                for k=1:length(obj.ciphertext)
                    if a(k)==i
                        Occurences(i)=Occurences(i)+1;
                    end
                end
            end
        end
        function obj=attack(obj)
            % A function that returns a new Attack object, with the same
            % ciphertext but a new key
            % Defining the vector corresponding to the frequency of letters
            % in English from rare to common
            EngLetFreq=[26,17,24,10,11,22,2,16,25,7,6,23,13,21,3,12,4,18,8,19,14,9,15,1,20,5];
            % Working out the PermutationKey of EngLetFreq
            A=PermutationKey(EngLetFreq);
            % Counting the numbers of each letter in the desired object
            FreqInText=lettercount(obj);
            % Working out the matching permutation of 1 to 26 given the
            % letter counts in FreqInText
            FreqInText=permutation(FreqInText);
            % Working out the PermutationKey of FreqInText
            B=PermutationKey(FreqInText);
            % Setting the FrequencyAttack in the desired format
            obj=Attack(obj.ciphertext);
            % Working out the new key
            obj.key=mtimes(B,invertion(A));
            % Setting the past property as the empty list 
            obj.past=List([],[]);
        end
        function CipherSection=sample(obj)
            % A function that displays a random piece of the ciphertext,
            % decrypted with the current key, of 300 characters in length
            % Working out the length of the ciphertext
            a=length(obj.ciphertext);
            % Selecting a random integer a between 1 and a (inclusive)
            b=randi(a);
            % Setting the upperbound so a ciphertext of length 300 can be
            % obtained i.e. b:c
            c=b+299;
            if b<length(obj.ciphertext)-299
                CipherSection=obj.ciphertext(b:c);
            else 
                disp('No ciphertext displayed as there are less than 300 characters in the sample');
            end
            % Displaying the sample of the ciphertext decrypted with the
            % current key
            CipherSection=decryption(obj.key,CipherSection);
        end
        function obj=swap(obj,x,y)
            % The function swaps two letters in the key of the object
            % inputted by calling the swap method in the PermutationKey
            % class
            % Setting the key to the new key with two letters swapped
            obj.key=swap(obj.key,x,y);
            % Adding the 2 letters swapped into a list that contains all
            % the swaps made, which is stored as the past property
            obj.past=List([x,y],obj.past);
        end
        function obj=undo(obj)
            % The function reverts the previous swap, or if there's no undo
            % information displays an appropriate message
            % Checking if the tail of the list is empty
            if isempty(obj.past.tail)
                disp('There is no undo information')
                return
            end    
            % Locating the previous swap in the list
            PreviousSwap=obj.past.head;
            % Reversing the previous swap
            obj.key=swap(obj.key,PreviousSwap(1),PreviousSwap(2));
            % Removing the previous swap from the past property
            obj.past=obj.past.tail;
        end
        function NEnglishWords=score(obj)
        % The function counts the number of occurences of common english words,
        % encrypted with the current key, in the ciphertext
        CommonWords={'THE','ARE','WAS','WERE','AND','THAT','HAVE','FOR','NOT','WITH','YOU'};
        vector=zeros(1,11);
        for i=1:11
            vector(i)=length(strfind(obj.ciphertext,encryption(obj.key,CommonWords{i})));
        end
        NEnglishWords=sum(vector);
        end
    end
end