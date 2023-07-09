classdef PermutationKey
    % PermutationKey stores and handles permutation keys.
    % A key is any permutation of the alphabet.
    % The identity permutation, the alphabet, is stored as the vector 1:26.
    
    properties
        perm
    end
    
    methods
        function obj = PermutationKey(p)
            % The Constructor Method: Takes a permutation p of the numbers
            % 1 to 26 and creates a PermutationKey storing that permutation
            % as it's perm property
            if nargin==0
                obj.perm=randperm(26);
            elseif ischar(p)==1 && length(p)==26
                obj.perm=double(p)-64; 
            elseif length(p)==26
                obj.perm=p;
            else
                disp('Input is not valid')
            end
        end
        function disp(obj)
            % A display method that shows PermutationKey as a permutation of
            % the alphabet
            disp(char(obj.perm+64))
        end
        function Composition=mtimes(l,m)
            % The function takes two keys l and m and gives their
            % composition
            % Setting a zeros vector for the Composition
            Composition=zeros(1,26);
            % Composing the two keys elementwise
            for i=1:26
                Composition(i)=l.perm(m.perm(i));
            end
            % Reverting the numbers back to letters
            Composition=PermutationKey(Composition);
        end
        function Inverse=invertion(K)
            % The function gives the inverse key of the key K
            % Setting a zeros vector for the Inverse
            Inverse=zeros(1,26);
            for i=1:26
                Inverse(K.perm(i))=i;
            end
            Inverse=PermutationKey(Inverse);
        end
        function EncryptMessage=encryption(k,m)
            % The function encrypts the message using the key k
            % Making the message to uppercase
            m=upper(m);
            % Changing the characters into there corresponding ASCII
            % numbers
            m=double(m);
            % Setting a zeros vector for EncryptMessage
            EncryptMessage=zeros(1,length(m));
            for i=1:length(m)
                if m(i)<65 || m(i)>90
                    EncryptMessage(i)=m(i);
                    continue
                else
                    EncryptMessage(i)=m(i)-64;
                    EncryptMessage(i)=k.perm(EncryptMessage(i));
                    EncryptMessage(i)=EncryptMessage(i)+64;
                end
            end
            EncryptMessage=char(EncryptMessage);
        end
        function DecryptMessage=decryption(k,m)
            % The function decrypts a message m with the key k by
            % encrypting with the inverse key
            % Calling the Inverse Key
            InverseKey=invertion(k);
            DecryptMessage=encryption(InverseKey,m);
        end
        function Switch=swap(k,x,y)
            % The function swaps two letters in the key
            % Finding the vector corresponding to the key k
            Switch=k.perm;
            % Working out the number in the range 1 to 26 that corresponds
            % with the letters x and y
            x=x-64;
            y=y-64;
            % Swapping the positions of x and y
            Switch([x y])=Switch([y x]);
            % Converting the vector back into it's PermutationKey
            Switch=PermutationKey(Switch);
        end
        
    end
end
