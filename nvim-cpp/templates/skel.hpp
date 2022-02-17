#ifndef @BASENAME_UPPER@_HPP
# define @BASENAME_UPPER@_HPP
# include <iostream>

class @BASENAME@ {
public:
    @BASENAME@(void);
    @BASENAME@(const std::string & name);
    ~@BASENAME@(void);
    @BASENAME@(const @BASENAME@ & other);
    @BASENAME@ & operator=(const @BASENAME@ & other);

    @CURSOR@void setName(const std::string & name);
    std::string getName(void) const;

private:
    std::string _name;
};

std::ostream & operator<<(std::ostream & o, @BASENAME@ const & other);

#endif
